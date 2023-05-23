import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class NoteGrid extends StatelessWidget {
  const NoteGrid({
    super.key,
    required this.title,
    required this.date,
    required this.content,
    required this.onTap,
    this.onLongPress,
  });

  final String title;
  final int date;
  final String content;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 300),
        padding: const EdgeInsets.all(10),
        clipBehavior: Clip.hardEdge,
        height: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                offset: Offset(5, 5),
                spreadRadius: -14,
                blurRadius: 18,
                color: Color.fromRGBO(0, 0, 0, 1),
              )
            ],
            color: Theme.of(context).colorScheme.surface),
        child: Column(
          children: [
            Text(title),
            Text(
              "Yesterday, 07:26",
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Colors.grey.shade600),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: MarkdownBody(
                data: content,
                styleSheet: MarkdownStyleSheet(
                    textScaleFactor: 0.4,
                    checkbox: const TextStyle(fontSize: 10)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
