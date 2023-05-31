import 'package:flutter/material.dart';

/// The `SettingsIcon` class is a stateless widget that displays an icon with a colored background and
/// rounded corners.
class SettingsIcon extends StatelessWidget {
  /// The `SettingsIcon` class is a stateless widget that displays an icon with a colored background and
  /// rounded corners.
  const SettingsIcon({required this.icon, required this.bgColor, super.key});

  /// `final IconData icon;` is declaring a final variable named `icon` of type `IconData`. This variable
  /// is used to store the icon that will be displayed in the `SettingsIcon` widget. The `IconData` class
  /// is used to represent a glyph from a font family such as Material Icons or FontAwesome.
  final IconData icon;

  /// `final Color bgColor;` is declaring a final variable named `bgColor` of type `Color`. This variable
  /// is used to store the background color that will be displayed behind the icon in the `SettingsIcon`
  /// widget. The `Color` class is used to represent a color in Flutter.
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration:
          BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(5)),
      child: Icon(icon),
    );
  }
}
