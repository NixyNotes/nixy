import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:nextcloudnotes/core/extensions/markdown_clear.extension.dart';

class NoteGrid extends StatelessWidget {
  const NoteGrid({
    required this.title,
    required this.date,
    required this.content,
    required this.onTap,
    super.key,
    this.onLongPress,
    this.isFavorite = false,
  });

  final String title;
  final int date;
  final String content;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final dateFormatted =
        DateFormat('E,HH:m').format(DateTime.fromMillisecondsSinceEpoch(date));

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
            )
          ],
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: isFavorite
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.center,
              children: [
                if (isFavorite)
                  const Icon(
                    EvaIcons.star,
                    color: Colors.orangeAccent,
                    size: 12,
                  ),
                Expanded(
                  child: Text(
                    title.removeMarkdown(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Text(
              dateFormatted,
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
                imageBuilder: (uri, title, alt) =>
                    CachedNetworkImage(imageUrl: uri.toString()),
                styleSheet: MarkdownStyleSheet(
                  textScaleFactor: 0.4,
                  checkbox: const TextStyle(fontSize: 10),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
