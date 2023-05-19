import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:nextcloudnotes/components/future_builder.component.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/note/controllers/note-view.controller.dart';
import 'package:nextcloudnotes/models/note.model.dart';

@RoutePage()
class NoteView extends StatefulWidget {
  const NoteView({super.key, required this.noteId});

  final int noteId;

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final controller = getIt<NoteViewController>();

  @override
  void initState() {
    super.initState();
    controller.fetchNote(widget.noteId);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        body: AppFutureBuilder<Note>(
      future: controller.fetchNote(widget.noteId),
      child: (data) {
        return Column(
          children: [
            Text(
              data?.title ?? "selam",
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Text(data?.title ?? "sel2am"),
          ],
        );
      },
    ));
  }
}
