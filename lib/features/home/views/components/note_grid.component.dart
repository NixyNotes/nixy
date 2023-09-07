import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:nextcloudnotes/core/extensions/markdown_clear.extension.dart';

/// The NoteGrid class is a stateless widget that displays a note with a title, date, content, and
/// optional favorite icon, and allows for tapping and long pressing.
class NoteGrid extends StatelessWidget {
  /// The NoteGrid class is a stateless widget that displays a note with a title, date, content, and
  /// optional favorite icon, and allows for tapping and long pressing.
  const NoteGrid({
    required this.title,
    required this.date,
    required this.content,
    required this.onTap,
    super.key,
    this.onLongPress,
    this.isFavorite = false,
  });

  /// The line `final String title;` is declaring a final variable `title` of type `String` in the
  /// `NoteGrid` class. This variable is required for constructing an instance of the `NoteGrid` widget
  /// and represents the title of the note being displayed.
  final String title;

  /// The line `final int date;` is declaring a final variable `date` of type `int` in the `NoteGrid`
  /// class. This variable is required for constructing an instance of the `NoteGrid` widget and
  /// represents the date of the note being displayed, stored as the number of milliseconds since the
  /// epoch (January 1, 1970, 00:00:00 UTC). The date is later formatted using the `DateFormat` class to
  /// display the day of the week and time in a specific format.
  final int date;

  /// The line `final String content;` is declaring a final variable `content` of type `String` in the
  /// `NoteGrid` class. This variable is required for constructing an instance of the `NoteGrid` widget
  /// and represents the content of the note being displayed. The content is later displayed using the
  /// `MarkdownBody` widget, which allows for rendering of Markdown syntax in the text.
  final String content;

  /// The line `final bool isFavorite;` is declaring a final variable `isFavorite` of type `bool` in the
  /// `NoteGrid` class. This variable is optional for constructing an instance of the `NoteGrid` widget
  /// and represents whether the note being displayed is marked as a favorite or not. If `isFavorite` is
  /// `true`, a star icon is displayed next to the note's title.
  final bool isFavorite;

  /// The line `final VoidCallback onTap;` is declaring a final variable `onTap` of type `VoidCallback` in
  /// the `NoteGrid` class. This variable is required for constructing an instance of the `NoteGrid`
  /// widget and represents the function that will be called when the user taps on the note. The
  /// `VoidCallback` type is a function type that takes no arguments and returns no value. This allows for
  /// passing a function as a parameter to the `NoteGrid` widget that will be executed when the user taps
  /// on the note.
  final VoidCallback onTap;

  /// The line `final VoidCallback? onLongPress;` is declaring a final nullable variable `onLongPress` of
  /// type `VoidCallback` in the `NoteGrid` class. This variable is optional for constructing an instance
  /// of the `NoteGrid` widget and represents the function that will be called when the user long presses
  /// on the note. The `VoidCallback` type is a function type that takes no arguments and returns no
  /// value
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
