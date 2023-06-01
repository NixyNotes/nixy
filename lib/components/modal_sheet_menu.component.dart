import 'package:flutter/material.dart';
import 'package:pull_down_button/pull_down_button.dart';

/// The `ModalSheetMenu` class is a stateless widget that displays a list of `PullDownMenuItem` objects
/// as a column of `ListTile` widgets within a safe area.
class ModalSheetMenu extends StatelessWidget {
  /// The `ModalSheetMenu` class is a stateless widget that displays a list of `PullDownMenuItem` objects
  /// as a column of `ListTile` widgets within a safe area.
  const ModalSheetMenu({required this.items, super.key});

  /// `final List<PullDownMenuItem> items;` is declaring a final variable `items` of type
  /// `List<PullDownMenuItem>`. This variable is used to store a list of `PullDownMenuItem` objects that
  /// will be displayed as a column of `ListTile` widgets in the `ModalSheetMenu` widget. The `required`
  /// keyword before `this.items` indicates that this parameter is mandatory and must be provided when
  /// creating an instance of the `ModalSheetMenu` widget.
  final List<PullDownMenuItem> items;

  /// The `itemsToListTile` getter is a computed property that converts the list of `PullDownMenuItem`
  /// objects (`items`) into a list of `ListTile` widgets. It does this by using the `map()` method to
  /// iterate over each `PullDownMenuItem` object in the `items` list and create a corresponding
  /// `ListTile` widget with the same title, icon, and `onTap` function. The `toList()` method is then
  /// called on the resulting `Iterable` to convert it back into a list of `ListTile` widgets. The
  /// `isDestructive` property of each `PullDownMenuItem` is used to set the text color of the `ListTile`
  /// to red if it is `true`.
  List<ListTile> get itemsToListTile => items
      .map(
        (e) => ListTile(
          leading: e.icon != null ? Icon(e.icon) : null,
          title: Text(
            e.title,
            style: TextStyle(color: e.isDestructive ? Colors.redAccent : null),
          ),
          onTap: e.onTap,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: itemsToListTile,
      ),
    );
  }
}
