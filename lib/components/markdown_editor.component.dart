import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/features/note/controllers/note_view.controller.dart';
import 'package:nextcloudnotes/models/keyboard_actions.model.dart';
import 'package:nixi_markdown/nixi_markdown.dart';

/// A workaround for making checkbox clickable
class MarkdownEd extends MarkdownElementBuilder {
  @override
  Widget? visitText(md.Text text, TextStyle? preferredStyle) {
    final controller = getIt<NoteViewController>();

    void onClick() {
      if (controller.markdownController.text.contains('- [ ] ${text.text}')) {
        controller.markdownController.text = controller.markdownController.text
            .replaceFirst('- [ ] ${text.text}', '- [x] ${text.text}');
      } else {
        controller.markdownController.text = controller.markdownController.text
            .replaceFirst('- [x] ${text.text}', '- [ ] ${text.text}');
      }

      controller
        ..editMode = !controller.editMode
        ..editMode = !controller.editMode
        ..updateNote(controller.note.id, controller.note);
    }

    return InkWell(
      onTap: onClick,
      child: Text(text.text),
    );
  }
}

/// The MarkdownEditor class is a widget that allows users to edit and preview markdown text with
/// undo/redo functionality and a toolbar for formatting options.
class MarkdownEditor extends StatelessWidget {
  /// The MarkdownEditor class is a widget that allows users to edit and preview markdown text with
  /// undo/redo functionality and a toolbar for formatting options.
  const MarkdownEditor({
    required this.focusNode,
    required this.controller,
    required this.undoHistoryController,
    super.key,
    this.renderPreview = false,
  });

  /// `final FocusNode focusNode;` is declaring a final variable `focusNode` of type `FocusNode`. This
  /// variable is used to control the focus of the text field in the MarkdownEditor widget. It is passed
  /// as a parameter to the constructor of the MarkdownEditor widget and then used in the
  /// KeyboardActionsItem widget to specify the focus node for the text field.
  final FocusNode focusNode;

  /// `final TextEditingController controller;` is declaring a final variable `controller` of type
  /// `TextEditingController`. This variable is used to control the text field in the MarkdownEditor
  /// widget. It is passed as a parameter to the constructor of the MarkdownEditor widget and then used in
  /// the TextField widget to specify the controller for the text field. This allows the widget to read
  /// and modify the text in the text field.
  final TextEditingController controller;

  /// `final bool? renderPreview;` is declaring a nullable boolean variable `renderPreview`. It is used as
  /// a parameter in the constructor of the `MarkdownEditor` widget to determine whether to render the
  /// preview of the markdown text or not. If `renderPreview` is `true`, the `Markdown` widget is returned
  /// to display the preview of the markdown text. If `renderPreview` is `false` or `null`, the
  /// `TextField` widget is returned to allow the user to edit the markdown text.
  final bool? renderPreview;

  /// `final UndoHistoryController undoHistoryController;` is declaring a final variable
  /// `undoHistoryController` of type `UndoHistoryController`. This variable is used to control the
  /// undo/redo functionality of the text field in the MarkdownEditor widget. It is passed as a parameter
  /// to the constructor of the MarkdownEditor widget and then used in the TextField widget to specify the
  /// undo controller for the text field. This allows the widget to keep track of the user's editing
  /// history and provide undo/redo functionality.
  final UndoHistoryController undoHistoryController;

  @override
  Widget build(BuildContext context) {
    final markdownTools = NixiMarkdownToolbarTools(controller);
    final keyboardActions = <KeyboardActionItem>[
      KeyboardActionItem(
        icon: const Icon(Icons.format_size),
        onTap: markdownTools.h1,
      ),
      KeyboardActionItem(
        icon: const Icon(Icons.format_list_bulleted_add),
        onTap: markdownTools.checkBoxList,
      ),
      KeyboardActionItem(
        icon: const Icon(Icons.format_list_bulleted),
        onTap: markdownTools.list,
      ),
      KeyboardActionItem(
        icon: const Icon(Icons.format_bold_outlined),
        onTap: markdownTools.bold,
      ),
      KeyboardActionItem(
        icon: const Icon(Icons.format_strikethrough),
        onTap: markdownTools.strikethrough,
      ),
      KeyboardActionItem(
        icon: const Icon(Icons.format_italic),
        onTap: markdownTools.italic,
      ),
    ];

    List<Widget Function(FocusNode)> keyboardActionItemToButtons() {
      return keyboardActions.map((e) {
        return (_) => IconButton(onPressed: e.onTap, icon: e.icon);
      }).toList();
    }

    KeyboardActionsConfig config() => KeyboardActionsConfig(
          nextFocus: false,
          keyboardBarColor: Theme.of(context).primaryColor,
          actions: [
            KeyboardActionsItem(
              focusNode: focusNode,
              toolbarButtons: [
                (s) {
                  return ValueListenableBuilder(
                    valueListenable: undoHistoryController,
                    builder: (context, value, child) {
                      if (value.canRedo && value.canRedo) {
                        return Row(
                          children: [
                            IconButton(
                              onPressed: undoHistoryController.undo,
                              icon: const Icon(Icons.undo),
                            ),
                            IconButton(
                              onPressed: undoHistoryController.redo,
                              icon: const Icon(Icons.redo),
                            )
                          ],
                        );
                      }

                      if (value.canUndo) {
                        return IconButton(
                          onPressed: undoHistoryController.undo,
                          icon: const Icon(Icons.undo),
                        );
                      }
                      if (value.canRedo) {
                        return IconButton(
                          onPressed: undoHistoryController.redo,
                          icon: const Icon(Icons.redo),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  );
                },
                ...keyboardActionItemToButtons()
              ],
            )
          ],
        );

    return KeyboardActions(
      enable: renderPreview != null && !renderPreview!,
      disableScroll: true,
      isDialog: true,
      config: config(),
      child: _MarkdownEditor(
        undoHistoryController: undoHistoryController,
        focusNode: focusNode,
        controller: controller,
        renderPreview: renderPreview,
      ),
    );
  }
}

class _MarkdownEditor extends StatelessWidget {
  const _MarkdownEditor({
    required this.focusNode,
    required this.controller,
    required this.undoHistoryController,
    this.renderPreview = false,
  });

  final FocusNode focusNode;
  final TextEditingController controller;
  final bool? renderPreview;
  final UndoHistoryController undoHistoryController;

  @override
  Widget build(BuildContext context) {
    if (renderPreview != null && renderPreview!) {
      return Markdown(
        selectable: true,
        data: controller.text,
        builders: {'li': MarkdownEd()},
        imageBuilder: (uri, title, alt) =>
            CachedNetworkImage(imageUrl: uri.toString()),
        styleSheet: MarkdownStyleSheet(
          checkbox: const TextStyle(color: Colors.orangeAccent),
        ),
      );
    }

    return TextField(
      focusNode: focusNode,
      undoController: undoHistoryController,
      autofocus: true,
      maxLines: null,
      expands: true,
      decoration: const InputDecoration(border: InputBorder.none),
      controller: controller,
      keyboardType: TextInputType.multiline,
      inputFormatters: [NewlineFormatter()],
    );
  }
}
