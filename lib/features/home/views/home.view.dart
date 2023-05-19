import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nextcloudnotes/core/router/router.gr.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/core/storage/auth.storage.dart';
import 'package:nextcloudnotes/features/home/controllers/home.controller.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

@RoutePage()
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authStorage = getIt<AuthStorage>();
    final controller = getIt<HomeViewController>();

    return AppScaffold(
        body: Column(
      children: [
        ElevatedButton(
            onPressed: () => authStorage.deleteAll(),
            child: const Text("delete all")),
        ElevatedButton(
            onPressed: () => controller.fetchCurrentUser(),
            child: const Text("delete ss")),
        Observer(builder: (_) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final note = controller.notes[index];

              return ListTile(
                title: Text(note.title ?? ""),
                onTap: () =>
                    context.router.navigate(NoteRoute(noteId: note.id)),
              );
            },
            itemCount: controller.notes.length,
            shrinkWrap: true,
          );
        })
      ],
    ));
  }
}
