import 'package:auto_route/auto_route.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nextcloudnotes/components/future_builder.component.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/note/controllers/note_view.controller.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nixi_markdown/formatters/newline_formatter.dart';

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
    controller.init(widget.noteId);
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
        controller.markdownController.text = data?.content ?? "se";

        return AppScaffold(
            title: data?.title,
            actions: [
              IconButton(
                  onPressed: () {
                    controller
                        .deleteNote(data?.id ?? 0)
                        .then((value) => context.router.back());
                  },
                  icon: const Icon(EvaIcons.trash2Outline)),
              Observer(
                builder: (context) {
                  if (controller.isTextFieldFocused) {
                    return ElevatedButton(
                        onPressed: () => controller.onTapDone(data!.id, data),
                        child: const Text("Done"));
                  }

                  return const SizedBox.shrink();
                },
              )
            ],
            body: Column(
              children: [
                Expanded(
                  child: Observer(builder: (_) {
                    return GestureDetector(
                      onDoubleTap: controller.toggleEditMode,
                      child: controller.editMode
                          ? TextField(
                              focusNode: controller.focusNode,
                              autofocus: true,
                              maxLines: null,
                              controller: controller.markdownController,
                              keyboardType: TextInputType.multiline,
                              inputFormatters: [NewlineFormatter()],
                            )
                          : MarkdownBody(
                              data: controller.markdownController.text,
                              styleSheet: MarkdownStyleSheet(
                                  checkbox: const TextStyle(
                                      color: Colors.orangeAccent)),
                            ),
                    );
                  }),
                )
              ],
            ));
      },
    );
  }
}
