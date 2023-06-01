import 'package:nextcloudnotes/core/utils/clear_markdown.dart';

/// This is an extension method in Dart that adds a new method called `removeMarkdown()` to the `String`
/// class. The method uses the `clearMarkdownHeders()` function from the `clear_markdown.dart` file to
/// remove any markdown headers from the string and returns the modified string. This extension method
/// can be used on any string object in the codebase.
extension ClearMarkdown on String {
  /// This function removes markdown headers from a given string.
  ///
  /// Returns:
  ///   The method `removeMarkdown()` is returning the result of calling the method
  /// `clearMarkdownHeaders()` on the current object (`this`) after removing any markdown headers from the
  /// string. The return type of the method is not specified in the code snippet, but it is likely to be a
  /// `String`.
  String removeMarkdown() {
    return clearMarkdownHeders(this);
  }
}
