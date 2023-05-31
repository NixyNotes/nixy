/// The function clears all markdown headers from a given text.
///
/// Args:
///   text (String): The input text that may contain markdown headers (lines starting with one or more #
/// symbols).
String clearMarkdownHeders(String text) {
  return text.replaceAll(RegExp('(?<!w)#(?!#s)', multiLine: true), '');
}
