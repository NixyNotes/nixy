import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/scheme/offline_queue.scheme.dart';
import 'package:nextcloudnotes/core/services/offline.service.dart';
import 'package:nextcloudnotes/core/services/toast.service.dart';
import 'package:nextcloudnotes/core/storage/note.storage.dart';
import 'package:nextcloudnotes/models/category.model.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nextcloudnotes/repositories/notes.repositories.dart';

part 'home.controller.g.dart';

/// If `isViewingCategory` is true, means that user is looking for category
/// posts.
ValueNotifier<bool> isViewingCategoryPosts = ValueNotifier(false);

/// Dispose `HomeViewController` instance
void disposeHomeController(HomeViewController instance) {
  instance.dispose();
}

@LazySingleton(dispose: disposeHomeController)

/// HomeViewController
class HomeViewController = _HomeViewControllerBase with _$HomeViewController;

abstract class _HomeViewControllerBase with Store {
  _HomeViewControllerBase(
    this._noteRepositories,
    this._toastService,
    this._noteStorage,
    this._offlineService,
    this._authController,
  );
  final NoteRepositories _noteRepositories;
  final ToastService _toastService;
  final NoteStorage _noteStorage;
  final OfflineService _offlineService;
  final AuthController _authController;

  @observable
  ObservableList<Note> notes = ObservableList();

  @observable
  bool syncing = false;

  @observable
  ObservableList<Note> selectedNotes = ObservableList();

  @observable
  ObservableList<CategoryModel> categories = ObservableList();

  late ReactionDisposer sortAutomaticallyDisposer;
  late ReactionDisposer showToastWhenSycingDisposer;
  late ReactionDisposer syncCategoriesWithPosts;

  late MotionToast? toast;

  Future<void> init([String? byCategoryName]) async {
    sortAutomaticallyDisposer = autorun((_) {
      notes.sort((a, b) => b.favorite ? 1 : 0);
    });

    showToastWhenSycingDisposer = autorun((_) {
      if (syncing) {
        toast = _toastService.showLoadingToast('Syncing...');
      } else {
        toast?.dismiss();
      }
    });

    syncCategoriesWithPosts = autorun((_) {
      if (notes.isNotEmpty) {
        categories.clear();
        fetchCategories();
      }
    });

    _authController.currentAccount.observe((_) async {
      await fetchNotes(byCategoryName);
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

  Future<List<Note>> _fetchRemoteNotes([String? byCategoryName]) async {
    List<Note> remoteNotes;

    if (byCategoryName != null) {
      remoteNotes =
          await _noteRepositories.fetchNotesByCategory(byCategoryName);
    } else {
      remoteNotes = await _noteRepositories.fetchNotes();
    }

    return remoteNotes;
  }

  Future<List<Note>> _fetchLocalNotes([String? byCategoryName]) async {
    var localNotes = <Note>[];
    if (byCategoryName != null) {
      localNotes = await _noteStorage.getAllNotesByCategory(byCategoryName);
    } else {
      localNotes = await _noteStorage.getAllNotes();
    }

    return localNotes;
  }

  @action
  Future<void> fetchNotes([String? byCategoryName]) async {
    final localNotes = await _fetchLocalNotes(byCategoryName);

    if (localNotes.isNotEmpty) {
      notes = ObservableList.of(localNotes);

      if (_offlineService.hasInternetAccess) {
        syncing = true;
        await _offlineService.runQueue();
        final remoteNotes = await _fetchRemoteNotes(byCategoryName);
        notes = ObservableList.of(remoteNotes);
        syncing = false;

        _noteStorage.saveAllNotes(remoteNotes);
        await _syncLocalWithRemote(localNotes, remoteNotes);
      }
    } else {
      if (_offlineService.hasInternetAccess) {
        final remoteNotes = await _fetchRemoteNotes(byCategoryName);

        notes = ObservableList.of(remoteNotes);
        _noteStorage.saveAllNotes(remoteNotes);
      }
    }
  }

  Future<void> _syncLocalWithRemote(
    List<Note> localNotes,
    List<Note> remoteNotes,
  ) async {
    final isNoteEquals = listEquals(remoteNotes, localNotes);

    if (!isNoteEquals) {
      _noteStorage
        ..deleteAll()
        ..saveAllNotes(remoteNotes);
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
    final internetAccess = _offlineService.hasInternetAccess;

    if (!internetAccess) {
      _offlineService.addQueue(
        OfflineQueueAction.UPDATE,
        noteId: note.id,
        noteAsJson: jsonEncode(note),
      );

      return;
    }

    await _noteRepositories.updateNote(note.id, note);
  }

  @action
  Future<void> deleteNote(Note note) async {
    if (_offlineService.hasInternetAccess) {
      await _noteRepositories.deleteNote(note.id);
    } else {
      _offlineService.addQueue(OfflineQueueAction.DELETE, noteId: note.id);
    }

    _noteStorage.deleteNote(note);

    notes.removeWhere((element) => element.id == note.id);

    _toastService.showTextToast(
      'Deleted ${note.title}',
      type: ToastType.success,
    );
  }

  @action
  Future<void> bunchDeleteNotes() async {
    final futures = <Future<bool>>[];
    final internetAccess = _offlineService.hasInternetAccess;

    for (final note in selectedNotes) {
      if (internetAccess) {
        final future = _noteRepositories.deleteNote(note.id);
        futures.add(future);
      }
    }

    if (!internetAccess) {
      for (final note in selectedNotes) {
        _noteStorage.deleteNote(note);
        notes.removeWhere((element) => element.id == note.id);
        _offlineService.addQueue(OfflineQueueAction.DELETE, noteId: note.id);
      }
      _toastService.showTextToast(
        'Deleted (${selectedNotes.length}) notes.',
        type: ToastType.success,
      );
      selectedNotes.clear();
      return;
    }

    await Future.wait<bool>(futures).then((value) {
      for (final note in selectedNotes) {
        notes.removeWhere((element) => element.id == note.id);
      }

      _toastService.showTextToast(
        'Deleted (${selectedNotes.length}) notes.',
        type: ToastType.success,
      );
      selectedNotes.clear();
    });
  }

  @action
  Future<void> addToSelectedNote(Note note) async {
    if (selectedNotes.where((element) => element.id == note.id).isNotEmpty) {
      selectedNotes.removeWhere((element) => element.id == note.id);
      return;
    }

    selectedNotes.add(note);
  }

  void dispose() {
    sortAutomaticallyDisposer();
    showToastWhenSycingDisposer();
    syncCategoriesWithPosts();
    isViewingCategoryPosts.value = false;
  }
}
