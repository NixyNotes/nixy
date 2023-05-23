import 'package:auto_route/auto_route.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:nextcloudnotes/components/markdown_editor.component.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/shared/components/scaffold.component.dart';
import 'package:nextcloudnotes/features/new_note/controllers/new_note.controller.dart';
import 'package:nixi_markdown/toolbar.dart';

@RoutePage()
class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  final NewNoteController controller = getIt<NewNoteController>();
  late final NixiMarkdownToolbarTools markdownTools;

  KeyboardActionsConfig get _config => KeyboardActionsConfig(
        nextFocus: false,
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Theme.of(context).primaryColor,
        actions: [
          KeyboardActionsItem(focusNode: controller.focusNode, toolbarButtons: [
            (s) {
              return IconButton(
                  onPressed: markdownTools.bold,
                  icon: const Icon(Icons.format_bold_outlined));
            },
            (s) {
              return IconButton(
                  onPressed: markdownTools.italic,
                  icon: const Icon(Icons.format_italic_outlined));
            },
            (s) {
              return IconButton(
                  onPressed: markdownTools.strikethrough,
                  icon: const Icon(Icons.format_strikethrough));
            },
          ])
        ],
      );

  @override
  void initState() {
    super.initState();
    controller.init();
    markdownTools = NixiMarkdownToolbarTools(controller.markdownController);
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
            Observer(builder: (_) {
              return IconButton(
                  onPressed: controller.togglePreviewMode,
                  icon: Icon(controller.previewMode
                      ? EvaIcons.eyeOffOutline
                      : EvaIcons.eyeOutline));
            }),
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
                        child: const Text("Done"));
                  }
                }

                return const SizedBox.shrink();
              },
            )
          ],
          body: Observer(
            builder: (_) {
              return KeyboardActions(
                enable: true,
                disableScroll: true,
                isDialog: true,
                config: _config,
                child: MarkdownEditor(
                  focusNode: controller.focusNode,
                  controller: controller.markdownController,
                  renderPreview: controller.previewMode,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
