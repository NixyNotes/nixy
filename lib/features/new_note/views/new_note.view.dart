import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nextcloudnotes/components/markdown_editor.component.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/new_note/controllers/new_note.controller.dart';

// ignore: public_member_api_docs
class NewNoteView extends StatefulWidget {
// ignore: public_member_api_docs
  const NewNoteView({super.key, this.title, this.content});

  ///
  final String? title;

  ///
  final String? content;

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  final NewNoteController controller = getIt<NewNoteController>();

  @override
  void initState() {
    super.initState();
    controller.init(context, content: widget.content, localTitle: widget.title);
  }

  @override
  void dispose() {
    getIt.resetLazySingleton<NewNoteController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return AppScaffold(
          title: controller.title,
          actions: [
            Observer(
              builder: (_) {
                return IconButton(
                  onPressed: controller.togglePreviewMode,
                  icon: Icon(
                    controller.previewMode
                        ? EvaIcons.eyeOffOutline
                        : EvaIcons.eyeOutline,
                  ),
                );
              },
            ),
            Observer(
              builder: (context) {
                // If title is not null, means user has put some text
                // Therefore it is ok to show done
                if (controller.title != null) {
                  if (controller.isLoading) {
                    return const CircularProgressIndicator.adaptive();
                  } else {
                    return TextButton(
                      onPressed: controller.createNote,
                      child: const Text('Done'),
                    );
                  }
                }

                return const SizedBox.shrink();
              },
            )
          ],
          body: Observer(
            builder: (_) {
              return MarkdownEditor(
                undoHistoryController: controller.undoHistoryController,
                focusNode: controller.focusNode,
                controller: controller.markdownController,
                renderPreview: controller.previewMode,
              );
            },
          ),
        );
      },
    );
  }
}
