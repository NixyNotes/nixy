import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcloudnotes/components/modal_sheet_menu.component.dart';
import 'package:nextcloudnotes/core/config.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/router/parameters/home.parameters.dart';
import 'package:nextcloudnotes/core/router/router_meta.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/home/controllers/home.controller.dart';
import 'package:nextcloudnotes/features/home/views/components/category_grid.component.dart';
import 'package:nextcloudnotes/features/home/views/components/note_grid.component.dart';
import 'package:nextcloudnotes/features/home/views/components/note_list.component.dart';
import 'package:nextcloudnotes/features/home/views/components/search_deletage.component.dart';
import 'package:nextcloudnotes/models/list_view.model.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:pull_down_button/pull_down_button.dart';

/// Home view
class HomeView extends StatefulWidget {
  /// Home view
  const HomeView({super.key, this.byCategoryName});

  /// `final String? byCategoryName;` is declaring a nullable String variable named `byCategoryName`.
  /// This variable is used as a parameter in the
  /// `HomeView` constructor to indicate if the view is being filtered by a specific category name. If it
  /// is null, then the view will display all notes, otherwise it will only display notes that belong to
  /// the specified category.
  final String? byCategoryName;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = getIt<HomeViewController>();
  final authStorage = getIt<AuthController>();

  @override
  void initState() {
    super.initState();

    controller.init(widget.byCategoryName);

    Future.delayed(const Duration(milliseconds: 200), () {
      GoRouter.of(context).addListener(() {
        if (GoRouter.of(context).location.startsWith('/category-posts')) {
          getIt.resetLazySingleton<HomeViewController>();
        }
      });
    });
  }

  @override
  void dispose() {
    getIt.resetLazySingleton<HomeViewController>();
    super.dispose();
  }

  void navigateToPosts(String label) {
    final parameters = HomeParameters(
      categoryName: label,
    );

    context.pushNamed(
      RouterMeta.CategoryPosts.name,
      pathParameters: {'categoryName': label},
    );
  }

  void showSearchDialog() {
    showSearch(
      useRootNavigator: true,
      context: context,
      delegate: NixiSearchDelegate(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAppBar: widget.byCategoryName != null,
      bottomBar: _renderBottomBar(context),
      body: Column(
        children: [
          Observer(
            builder: (_) {
              if (widget.byCategoryName != null) {
                return const SizedBox.shrink();
              }

              if (controller.categories.isEmpty) {
                return const SizedBox.shrink();
              }

              return GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 5,
                  mainAxisExtent: 50,
                ),
                itemBuilder: (context, index) {
                  final category = controller.categories[index];

                  if (index >= 3) {
                    return CategoryGrid(
                      categoryName: 'More categories...',
                      onTap: () {
                        context.pushNamed(
                          RouterMeta.Categories.name,
                          extra: controller.categories,
                        );
                      },
                    );
                  }

                  return CategoryGrid(
                    categoryName: category.label,
                    onTap: () {
                      navigateToPosts(category.label);
                    },
                  );
                },
                itemCount: controller.categories.length >= 4
                    ? 4
                    : controller.categories.length,
              );
            },
          ),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: controller.fetchNotes,
              child: Observer(
                builder: (context) {
                  switch (controller.homeNotesView.value) {
                    case HomeListView.grid:
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 250,
                        ),
                        itemCount: controller.notes.length,
                        clipBehavior: Clip.antiAlias,
                        itemBuilder: (BuildContext context, int index) {
                          return _itemBuilder(index);
                        },
                      );
                    case HomeListView.list:
                      return ListView.builder(
                        itemCount: controller.notes.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _itemBuilder(index);
                        },
                      );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  PlatformWidget _itemBuilder(int index) {
    final note = controller.notes[index];
    final menuItems = [
      PullDownMenuItem(
        onTap: () => controller.addToSelectedNote(note),
        title: 'Select',
      ),
      PullDownMenuItem(
        icon: EvaIcons.star,
        iconColor: Colors.yellowAccent,
        onTap: () => controller.toggleFavorite(note),
        title: 'Favorite',
      ),
      PullDownMenuItem(
        onTap: () => controller.deleteNote(note),
        title: 'Delete',
        isDestructive: true,
      ),
    ];

    return PlatformWidget(
      material: (context, platform) => InkWell(
        onLongPress: () {
          showPlatformModalSheet<void>(
            context: context,
            builder: (_) {
              return Material(
                child: ModalSheetMenu(items: menuItems),
              );
            },
          );
        },
        child: Observer(
          builder: (context) {
            return _renderNote(note);
          },
        ),
      ),
      cupertino: (context, platform) {
        return PullDownButton(
          itemBuilder: (context) => menuItems,
          buttonBuilder: (context, showMenu) => Observer(
            builder: (context) {
              return _renderNote(note, showMenu);
            },
          ),
        );
      },
    );
  }

  Widget _renderNote(Note note, [void Function()? showMenu]) {
    var content = note.content;
    if (note.content.length >= NOTE_CONTENT_MAX_CHARACTERS) {
      content = note.content.substring(0, NOTE_CONTENT_MAX_CHARACTERS);
    }

    final noteView = controller.homeNotesView.value == HomeListView.grid
        ? NoteGrid(
            title: note.title,
            content: content,
            date: note.modified,
            isFavorite: note.favorite,
            onTap: () => controller.selectedNotes.isEmpty
                ? context.pushNamed(
                    RouterMeta.SingleNote.name,
                    pathParameters: {'id': note.id.toString()},
                  )
                : controller.addToSelectedNote(note),
            onLongPress: showMenu,
          )
        : NoteList(
            title: note.title,
            date: note.modified,
            category: note.category,
            isFavorite: note.favorite,
            onTap: () => controller.selectedNotes.isEmpty
                ? context.pushNamed(
                    RouterMeta.SingleNote.name,
                    pathParameters: {'id': note.id.toString()},
                  )
                : controller.addToSelectedNote(note),
            onLongPress: showMenu,
          );

    return Stack(
      children: [
        noteView,
        if (controller.selectedNotes
            .where((element) => element.id == note.id)
            .isNotEmpty)
          InkWell(
            onTap: () => controller.addToSelectedNote(note),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
              alignment: Alignment.bottomRight,
              child: const Icon(EvaIcons.checkmarkSquare2),
            ),
          ),
      ],
    );
  }

  Widget _renderBottomBar(BuildContext context) {
    return Observer(
      builder: (context) {
        if (controller.selectedNotes.isNotEmpty) {
          return Container(
            height: 80,
            alignment: Alignment.centerLeft,
            color: Theme.of(context).primaryColor,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      'Selected (${controller.selectedNotes.length})',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: controller.bunchDeleteNotes,
                        icon: const Icon(
                          EvaIcons.trashOutline,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
        return BottomNavigationBar(
          onTap: (value) {
            switch (value) {
              case 0:
                showSearchDialog();
              case 1:
                context.pushNamed(RouterMeta.NewNote.name);
              case 2:
                context.pushNamed(RouterMeta.Settings.name);
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(EvaIcons.search),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(EvaIcons.plus),
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(EvaIcons.moreHorizontalOutline),
              label: '',
            ),
          ],
          showUnselectedLabels: false,
          showSelectedLabels: false,
          landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        );
      },
    );
  }
}
