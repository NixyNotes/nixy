import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:nixi_markdown/formatters/newline_formatter.dart';

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
