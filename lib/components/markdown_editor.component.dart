import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:nixi_markdown/nixi_markdown.dart';

class MarkdownEditor extends StatelessWidget {
  const MarkdownEditor(
      {super.key,
      required this.focusNode,
      required this.controller,
      this.renderPreview});

  final FocusNode focusNode;
  final TextEditingController controller;
  final bool? renderPreview;

  @override
  Widget build(BuildContext context) {
    final NixiMarkdownToolbarTools markdownTools =
        NixiMarkdownToolbarTools(controller);

    KeyboardActionsConfig _config() => KeyboardActionsConfig(
          nextFocus: false,
          keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
          keyboardBarColor: Theme.of(context).primaryColor,
          actions: [
            KeyboardActionsItem(focusNode: focusNode, toolbarButtons: [
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

    return KeyboardActions(
      enable: true,
      disableScroll: true,
      isDialog: true,
      config: _config(),
      child: _MarkdownEditor(
        focusNode: focusNode,
        controller: controller,
        renderPreview: renderPreview,
      ),
    );
  }
}

class _MarkdownEditor extends StatelessWidget {
  const _MarkdownEditor(
      {required this.focusNode,
      required this.controller,
      this.renderPreview = false});

  final FocusNode focusNode;
  final TextEditingController controller;
  final bool? renderPreview;

  @override
  Widget build(BuildContext context) {
    if (renderPreview != null && renderPreview!) {
      return Markdown(
        data: controller.text,
        styleSheet: MarkdownStyleSheet(
          checkbox: const TextStyle(color: Colors.orangeAccent),
        ),
      );
    }

    return TextField(
      focusNode: focusNode,
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
