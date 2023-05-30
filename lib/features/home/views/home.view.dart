import 'package:auto_route/auto_route.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:nextcloudnotes/components/modal_sheet_menu.component.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/router/router.gr.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/home/controllers/home.controller.dart';
import 'package:nextcloudnotes/features/home/views/components/category_grid.component.dart';
import 'package:nextcloudnotes/features/home/views/components/note_grid.component.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:pull_down_button/pull_down_button.dart';

@RoutePage()
class HomeView extends StatefulWidget {
  HomeView({super.key, this.byCategoryName});

  String? byCategoryName;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = getIt<HomeViewController>();
  final authStorage = getIt<AuthController>();
  get listener => () {
        if (!isViewingCategoryPosts.value && widget.byCategoryName == null) {
          controller.init();
        }
      };

  @override
  void initState() {
    super.initState();

    if (!isViewingCategoryPosts.value) {
      controller.init();
    } else {
      controller.init(widget.byCategoryName);
    }

    isViewingCategoryPosts.addListener(listener);
  }

  @override
  void dispose() {
    getIt.resetLazySingleton<HomeViewController>();
    isViewingCategoryPosts.removeListener(listener);
    super.dispose();
  }

  navigateToPosts(String label) {
    isViewingCategoryPosts.value = true;
    context.router.push(HomeRoute(byCategoryName: label));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        showAppBar: widget.byCategoryName != null ? true : false,
        bottomBar: _renderBottomBar(context),
        body: Column(
          children: [
            Observer(builder: (_) {
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
                    mainAxisExtent: 50),
                itemBuilder: (context, index) {
                  final category = controller.categories[index];

                  if (index >= 3) {
                    return CategoryGrid(
                        categoryName: "More categories...",
                        onTap: () {
                          context.router.navigate(CategoriesRoute(
                              categories: controller.categories));
                        });
                  }

                  return CategoryGrid(
                      categoryName: category.label,
                      onTap: () {
                        navigateToPosts(category.label);
                      });
                },
                itemCount: controller.categories.length >= 4
                    ? 4
                    : controller.categories.length,
              );
            }),
            Expanded(
              child: Observer(
                builder: (context) {
                  return RefreshIndicator.adaptive(
                    onRefresh: () => controller.fetchNotes(),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              mainAxisExtent: 250),
                      itemCount: controller.notes.length,
                      clipBehavior: Clip.antiAlias,
                      itemBuilder: (BuildContext context, int index) {
                        final note = controller.notes[index];
                        final menuItems = [
                          PullDownMenuItem(
                            onTap: () => controller.addToSelectedNote(note),
                            title: "Select",
                          ),
                          PullDownMenuItem(
                            icon: EvaIcons.star,
                            iconColor: Colors.yellowAccent,
                            onTap: () => controller.toggleFavorite(note),
                            title: "Favorite",
                          ),
                          PullDownMenuItem(
                            onTap: () => controller.deleteNote(note),
                            title: "Delete",
                            isDestructive: true,
                          ),
                        ];

                        return PlatformWidget(
                          material: (context, platform) => InkWell(
                            onLongPress: () {
                              showPlatformModalSheet(
                                context: context,
                                builder: (_) {
                                  return Material(
                                      child: ModalSheetMenu(items: menuItems));
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
                                    ));
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }

  Stack _renderNote(Note note, [Function()? showMenu]) {
    return Stack(
      children: [
        NoteGrid(
          title: note.title,
          content: note.content,
          date: note.modified,
          isFavorite: note.favorite,
          onTap: () => controller.selectedNotes.isEmpty
              ? context.router.navigate(NoteRoute(noteId: note.id))
              : controller.addToSelectedNote(note),
          onLongPress: showMenu,
        ),
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
                      "Selected (${controller.selectedNotes.length})",
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
                          )),
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
                break;
              case 1:
                context.router.navigate(const NewNoteRoute());
                break;
              case 2:
                context.router.navigate(const SettingsRoute());
                break;
            }
          },
          items: [
            const BottomNavigationBarItem(
                icon: Icon(EvaIcons.search), label: ""),
            BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Icon(EvaIcons.plus),
                ),
                label: ""),
            const BottomNavigationBarItem(
              icon: Icon(EvaIcons.moreHorizontalOutline),
              label: "",
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
