import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// The NoteList class is a stateless widget that displays a note with a title, date, content, and
/// optional favorite icon, and allows for tapping and long pressing.
class NoteList extends StatelessWidget {
  /// The NoteList class is a stateless widget that displays a note with a title, date, content, and
  /// optional favorite icon, and allows for tapping and long pressing.
  const NoteList({
    required this.title,
    required this.date,
    required this.category,
    required this.onTap,
    super.key,
    this.onLongPress,
    this.isFavorite = false,
  });

  /// The line `final String title;` is declaring a final variable `title` of type `String` in the
  /// `NoteList` class. This variable is required for constructing an instance of the `NoteList` widget
  /// and represents the title of the note being displayed.
  final String title;

  /// The line `final int date;` is declaring a final variable `date` of type `int` in the `NoteList`
  /// class. This variable is required for constructing an instance of the `NoteList` widget and
  /// represents the date of the note being displayed, stored as the number of milliseconds since the
  /// epoch (January 1, 1970, 00:00:00 UTC). The date is later formatted using the `DateFormat` class to
  /// display the day of the week and time in a specific format.
  final int date;

  /// The line `final String category;` is declaring a final variable `category` of type `String` in the
  /// `NoteList` class. This variable is required for constructing an instance of the `NoteList` widget
  /// and represents the category of the note being displayed. It is later used to display the category in
  /// the UI.
  final String category;

  /// The line `final bool isFavorite;` is declaring a final variable `isFavorite` of type `bool` in the
  /// `NoteList` class. This variable is optional for constructing an instance of the `NoteList` widget
  /// and represents whether the note being displayed is marked as a favorite or not. If `isFavorite` is
  /// `true`, a star icon is displayed next to the note's title.
  final bool isFavorite;

  /// The line `final VoidCallback onTap;` is declaring a final variable `onTap` of type `VoidCallback` in
  /// the `NoteList` class. This variable is required for constructing an instance of the `NoteList`
  /// widget and represents the function that will be called when the user taps on the note. The
  /// `VoidCallback` type is a function type that takes no arguments and returns no value. This allows for
  /// passing a function as a parameter to the `NoteList` widget that will be executed when the user taps
  /// on the note.
  final VoidCallback onTap;

  /// The line `final VoidCallback? onLongPress;` is declaring a final nullable variable `onLongPress` of
  /// type `VoidCallback` in the `NoteList` class. This variable is optional for constructing an instance
  /// of the `NoteList` widget and represents the function that will be called when the user long presses
  /// on the note. The `VoidCallback` type is a function type that takes no arguments and returns no
  /// value
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    String renderSubtitle() {
      final dateFormatted = DateFormat('E,HH:m')
          .format(DateTime.fromMillisecondsSinceEpoch(date));

      final blocks = [dateFormatted];

      if (category.isNotEmpty) {
        blocks.insert(0, category);
      }

      return blocks.join(' - ');
    }

    return ListTile(
      title: Text(title),
      onLongPress: onLongPress,
      onTap: onTap,
      leading: isFavorite ? const Icon(EvaIcons.star) : null,
      subtitle: Text(
        renderSubtitle(),
        style: Theme.of(context)
            .textTheme
            .labelSmall
            ?.copyWith(color: Colors.grey.shade600),
      ),
    );
  }
}
