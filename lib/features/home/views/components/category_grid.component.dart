import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

/// The CategoryGrid class is a stateless widget that displays a container with a folder icon and a text
/// label, and responds to user taps with a callback function.
class CategoryGrid extends StatelessWidget {
  /// The CategoryGrid class is a stateless widget that displays a container with a folder icon and a text
  /// label, and responds to user taps with a callback function.
  const CategoryGrid({
    required this.categoryName,
    required this.onTap,
    super.key,
  });

  /// `final String categoryName;` is declaring a final variable named `categoryName` of type `String`.
  /// This variable is required as a parameter for the `CategoryGrid` widget and is used to display the
  /// category name in the UI.
  final String categoryName;

  /// `final VoidCallback onTap;` is declaring a final variable named `onTap` of type `VoidCallback`. This
  /// variable is required as a parameter for the `CategoryGrid` widget and is used to define the function
  /// that will be called when the user taps on the widget. The `VoidCallback` type is a function type
  /// that takes no arguments and returns no data. It is commonly used for defining callback functions
  /// that do not require any input or output.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [const Icon(EvaIcons.folderOutline), Text(categoryName)],
        ),
      ),
    );
  }
}
