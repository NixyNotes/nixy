// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:nixy_markdown/nixi_markdown.dart';

/// This code defines a map called `NixyMarkdownControllerPatterns` that maps regular expression
/// patterns to text styles. The regular expressions are defined in the `Patterns` class and the text
/// styles are defined elsewhere in the code (e.g. `HEADERS_STYLE`, `BOLD_TEXT_STYLE`, etc.). This map
/// is used by the `NixyMarkdownController` to apply the appropriate text styles to the text that
/// matches the regular expressions.
final NixyMarkdownControllerPatterns = {
  Patterns.HEADERS_PATTERN.pattern: HEADERS_STYLE,
  Patterns.BOLD_TEXT_PATTERN.pattern: BOLD_TEXT_STYLE,
  Patterns.CHECKBOX_LIST_PATTERN.pattern: const TextStyle(),
  Patterns.CHECKBOX_LIST_DONE_PATTERN.pattern: CHECKBOX_LIST_STYLE,
  Patterns.CODE_PATTERN.pattern: CODE_STYLE,
  Patterns.URL_PATTERN.pattern: URL_STYLE,
};
