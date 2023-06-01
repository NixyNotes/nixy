import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:nixi_markdown/nixi_markdown.dart';

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
                (s) {
                  return IconButton(
                    onPressed: markdownTools.bold,
                    icon: const Icon(Icons.format_bold_outlined),
                  );
                },
                (s) {
                  return IconButton(
                    onPressed: markdownTools.italic,
                    icon: const Icon(Icons.format_italic_outlined),
                  );
                },
                (s) {
                  return IconButton(
                    onPressed: markdownTools.strikethrough,
                    icon: const Icon(Icons.format_strikethrough),
                  );
                },
              ],
            )
          ],
        );

    return KeyboardActions(
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
        data: controller.text,
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
