import 'package:flutter/material.dart';

/// The `KeyboardActionItem` class represents an item with an icon and an `onTap` callback function.
class KeyboardActionItem {
  /// The `KeyboardActionItem` class represents an item with an icon and an `onTap` callback function.
  KeyboardActionItem({required this.onTap, required this.icon});

  /// `final VoidCallback onTap;` is declaring a final property named `onTap` of type `VoidCallback`. A
  /// `VoidCallback` is a function that takes no arguments and returns no value. In this case, the `onTap`
  /// property is used to store a callback function that will be executed when the corresponding item is
  /// tapped.
  final VoidCallback onTap;

  /// The `final Icon icon;` is declaring a final property named `icon` of type `Icon`. It is used to
  /// store an icon that will be displayed for the corresponding item.
  final Icon icon;
}
