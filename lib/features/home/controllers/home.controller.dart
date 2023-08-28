import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/controllers/app.controller.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/controllers/share_view.controller.dart';
import 'package:nextcloudnotes/core/router/router.dart';
import 'package:nextcloudnotes/core/router/router_meta.dart';
import 'package:nextcloudnotes/core/scheme/note.scheme.dart';
import 'package:nextcloudnotes/core/services/init_isar.dart';
import 'package:nextcloudnotes/core/services/provider.service.dart';
import 'package:nextcloudnotes/core/services/toast.service.dart';
import 'package:nextcloudnotes/core/storage/note.storage.dart';
import 'package:nextcloudnotes/models/category.model.dart';
import 'package:nextcloudnotes/models/list_view.model.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nextcloudnotes/repositories/notes.repositories.dart';

part 'home.controller.g.dart';

/// Dispose `HomeViewController` instance
void disposeHomeController(HomeViewController instance) {
  instance.dispose();
}

/// HomeViewController
@LazySingleton(dispose: disposeHomeController)
class HomeViewController = _HomeViewControllerBase with _$HomeViewController;

abstract class _HomeViewControllerBase with Store {
  _HomeViewControllerBase(
    this._noteRepositories,
    this._toastService,
    this._noteStorage,
    this._authController,
    this._appController,
    this._shareViewController,
    this._providerService,
  );
  final NoteRepositories _noteRepositories;
  final ToastService _toastService;
  final NoteStorage _noteStorage;
  final AuthController _authController;
  final AppController _appController;
  final ShareViewController _shareViewController;
  final ProviderService _providerService;

  @computed
  Observable<HomeListView> get homeNotesView => _appController.homeNotesView;

  @observable
  ObservableList<Note> notes = ObservableList();

  @observable
  bool syncing = false;

  @observable
  ObservableList<Note> selectedNotes = ObservableList();

  @observable
  ObservableList<CategoryModel> categories = ObservableList();

  @observable
  ObservableList<Note> _searchNotes = ObservableList();

  @computed
  ObservableList<ListTile> get searchNotes {
    final notess = _searchNotes
        .map(
          (element) => ListTile(
            title: Text(element.title),
            onTap: () {
              GoRouter.of(navigatorKey.currentContext!).pop();

              GoRouter.of(navigatorKey.currentContext!).pushNamed(
                RouterMeta.SingleNote.name,
                pathParameters: {'id': element.id.toString()},
              );
            },
          ),
        )
        .toList();

    return ObservableList.of(notess);
  }

  late ReactionDisposer sortAutomaticallyDisposer;
  late ReactionDisposer showToastWhenSycingDisposer;
  late ReactionDisposer syncCategoriesWithPosts;
  late StreamSubscription<dynamic> isarPostsWatcher;
  late Completer<void>? _toast;

  Future<void> init(BuildContext context, [String? byCategoryName]) async {
    await _shareViewController.init(context);
    sortAutomaticallyDisposer = autorun((_) {
      notes.sort((a, b) => b.favorite ? 1 : 0);
    });

    showToastWhenSycingDisposer = autorun((_) {
      if (syncing) {
        _toast = _toastService.showLoadingToast('Syncing...');
      } else {
        _toast?.complete();
      }
    });

    syncCategoriesWithPosts = autorun((_) {
      if (notes.isNotEmpty) {
        categories.clear();
        fetchCategories();
      }
    });

    _authController.currentAccount.observe((_) async {
      if (_authController.currentAccount.value != null) {
        await fetchNotes(byCategoryName);
      }
    });

    isarPostsWatcher = isarInstance.localNotes
        .watchLazy(fireImmediately: true)
        .listen((e) async {
      final updatedNotes = await _noteRepositories.fetchNotes();

      if (updatedNotes != null) {
        notes = ObservableList.of(updatedNotes);
      }
    });

    await fetchNotes(byCategoryName);
  }

  @action
  void fetchCategories() {
    for (final note in notes) {
      if (note.category.isNotEmpty) {
        final model = CategoryModel(label: note.category);

        categories.add(model);
      }
    }
  }

  @action
  Future<void> fetchNotes([String? byCategoryName]) async {
    final localNotes = await _noteRepositories.fetchNotes();

    if (localNotes != null) {
      notes = ObservableList.of(localNotes);
      syncing = false;
    }
  }

  Future<void> toggleFavorite(Note note) async {
    final model = Note(
      id: note.id,
      etag: note.etag,
      readonly: note.readonly,
      modified: DateTime.now().millisecondsSinceEpoch,
      title: note.title,
      category: note.category,
      content: note.content,
      favorite: !note.favorite,
    );

    await updateNote(model);

    final updatedList = notes
        .map((element) => element.id == note.id ? model : element)
        .toList();

    notes = ObservableList.of(updatedList);
  }

  Future<void> updateNote(Note note) async {
    _providerService.addAction(
      ProviderAction(
        action: ProviderActionType.UPDATE,
        note: note,
        noteId: note.id,
      ),
    );
  }

  @action
  Future<void> deleteNote(Note note) async {
    final action = ProviderAction(
      action: ProviderActionType.DELETE,
      note: note,
      noteId: note.id,
    );

    _providerService.addAction(action);

    notes.removeWhere((element) => element.id == note.id);

    _toastService.showTextToast(
      'Deleted ${note.title}',
      type: ToastType.success,
    );
  }

  @action
  Future<void> bunchDeleteNotes() async {
    for (final note in selectedNotes) {
      _providerService.addAction(
        ProviderAction(
          action: ProviderActionType.DELETE,
          noteId: note.id,
          note: note,
        ),
      );

      notes.removeWhere((element) => element.id == note.id);
    }

    _toastService.showTextToast(
      'Deleted (${selectedNotes.length}) notes.',
      type: ToastType.success,
    );
    selectedNotes.clear();
  }

  @action
  Future<void> addToSelectedNote(Note note) async {
    if (selectedNotes.where((element) => element.id == note.id).isNotEmpty) {
      selectedNotes.removeWhere((element) => element.id == note.id);
      return;
    }

    selectedNotes.add(note);
  }

  @action
  Future<void> search(String text) async {
    final notes = await _noteStorage.search(text);

    _searchNotes = ObservableList.of(notes);
  }

  void dispose() {
    sortAutomaticallyDisposer();
    showToastWhenSycingDisposer();
    syncCategoriesWithPosts();
    isarPostsWatcher.cancel();
  }
}
