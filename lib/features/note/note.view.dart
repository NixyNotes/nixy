import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcloudnotes/components/future_builder.component.dart';
import 'package:nextcloudnotes/components/markdown_editor.component.dart';
import 'package:nextcloudnotes/core/extensions/markdown_clear.extension.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/note/controllers/note_view.controller.dart';
import 'package:nextcloudnotes/models/note.model.dart';

/// The `NoteView` class is a stateful widget that displays a note and allows the user to edit and
/// delete it.
class NoteView extends StatefulWidget {
  /// The `NoteView` class is a stateful widget that displays a note and allows the user to edit and
  /// delete it.
  const NoteView({required this.noteId, super.key});

  /// `final int noteId;` is declaring a final variable `noteId` of type `int` in the `NoteView` class.
  /// This variable is used to store the ID of the note that is being viewed. It is passed as a parameter
  /// to the `NoteView` widget when it is created.
  final int noteId;

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final controller = getIt<NoteViewController>();

  @override
  void initState() {
    super.initState();
    controller.init(context);
  }

  @override
  void dispose() {
    getIt.resetLazySingleton<NoteViewController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppFutureBuilder<Note>(
      future: controller.fetchNote(widget.noteId),
      child: (data) {
        controller.markdownController.text = data?.content ?? 'se';

        return AppScaffold(
          title: data?.title.removeMarkdown(),
          actions: [
            IconButton(
              onPressed: () {
                controller
                    .deleteNote(data?.id ?? 0)
                    .then((value) => context.pop());
              },
              icon: const Icon(EvaIcons.trash2Outline),
            ),
            Observer(
              builder: (context) {
                if (!controller.editMode) {
                  return IconButton(
                    onPressed: controller.toggleEditMode,
                    icon: const Icon(EvaIcons.edit2Outline),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            Observer(
              builder: (context) {
                if (controller.editMode) {
                  return ElevatedButton(
                    onPressed: controller.onTapDone,
                    child: const Text('Done'),
                  );
                }

                return const SizedBox.shrink();
              },
            )
          ],
          body: Column(
            children: [
              Expanded(
                child: Observer(
                  builder: (_) {
                    return MarkdownEditor(
                      undoHistoryController: controller.undoHistoryController,
                      focusNode: controller.focusNode,
                      controller: controller.markdownController,
                      renderPreview: !controller.editMode,
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
