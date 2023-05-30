import 'package:nextcloudnotes/core/utils/clear_markdown.dart';

extension ClearMarkdown on String {
  String removeMarkdown() {
    return clearMarkdownHeders(this);
  }
}
