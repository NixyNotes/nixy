import 'package:auto_route/auto_route.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nextcloudnotes/core/controllers/auth.controller.dart';
import 'package:nextcloudnotes/core/extensions/async_value.extension.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/home/controllers/home.controller.dart';
import 'package:nextcloudnotes/models/note.model.dart';

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
        actions: [
          IconButton(
              onPressed: () => authStorage.logout(),
              icon: const Icon(EvaIcons.trash2Outline))
        ],
        body: Observer(
          builder: (context) {
            return controller.notes!.asyncValue<List<Note>>(
              pending: () => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              rejected: (error) => Text(error),
              fulfilled: (data) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    final note = data[index];

                    return ListTile(
                      title: Text(note.title),
                      subtitle: Text(note.category),
                    );
                  },
                  itemCount: data.length,
                );
              },
            );
          },
        ));
  }
}
