import 'package:auto_route/auto_route.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/extensions/async_value.extension.dart';
import 'package:nextcloudnotes/core/router/router.gr.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/home/controllers/home.controller.dart';
import 'package:nextcloudnotes/features/home/views/components/note_grid.component.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:pull_down_button/pull_down_button.dart';

@RoutePage()
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final controller = getIt<HomeViewController>();
  final authStorage = getIt<AuthController>();
  @override
  void initState() {
    super.initState();
    controller.fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        showAppBar: false,
        bottomBar: _renderBottomBar(context),
        body: Observer(
          builder: (context) {
            if (controller.notes == null) {
              return const SizedBox.shrink();
            }

            return controller.notes!.asyncValue<List<Note>>(
              pending: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              rejected: (error) => Text(error.toString()),
              fulfilled: (data) {
                return RefreshIndicator.adaptive(
                  onRefresh: () => controller.fetchNotes(),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                    itemCount: data.length,
                    clipBehavior: Clip.antiAlias,
                    itemBuilder: (BuildContext context, int index) {
                      final note = data[index];

                      return PlatformWidget(
                        material: (context, platform) => GestureDetector(
                          onLongPressDown: (details) {
                            showMenu(
                                context: context,
                                position: RelativeRect.fromLTRB(
                                    details.globalPosition.dx,
                                    details.globalPosition.dy,
                                    details.globalPosition.dx + 1,
                                    details.globalPosition.dy + 1),
                                items: [
                                  const PopupMenuItem(child: Text("qwe"))
                                ]);
                          },
                          child: NoteGrid(
                            title: note.title,
                            content: note.content,
                            date: note.modified,
                            onTap: () => context.router
                                .navigate(NoteRoute(noteId: note.id)),
                          ),
                        ),
                        cupertino: (context, platform) {
                          return PullDownButton(
                              itemBuilder: (context) => [
                                    PullDownMenuItem(
                                      title: 'Menu item',
                                      onTap: () {},
                                    ),
                                    const PullDownMenuDivider(),
                                    PullDownMenuItem(
                                      title: 'Menu item 2',
                                      onTap: () {},
                                    ),
                                  ],
                              buttonBuilder: (context, showMenu) => NoteGrid(
                                    title: note.title,
                                    content: note.content,
                                    date: note.modified,
                                    onTap: () => context.router
                                        .navigate(NoteRoute(noteId: note.id)),
                                    onLongPress: showMenu,
                                  ));
                        },
                      );
                      return null;
                    },
                  ),
                );
              },
            );
          },
        ));
  }

  BottomNavigationBar _renderBottomBar(BuildContext context) {
    return BottomNavigationBar(
      onTap: (value) {
        switch (value) {
          case 0:
            break;
          case 1:
            context.router.navigate(const NewNoteRoute());
            break;
          case 2:
            break;
        }
      },
      items: [
        const BottomNavigationBarItem(icon: Icon(EvaIcons.search), label: ""),
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
  }
}
