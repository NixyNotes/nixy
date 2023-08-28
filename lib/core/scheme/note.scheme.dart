// ignore_for_file: public_member_api_docs

import 'package:isar/isar.dart';
import 'package:nextcloudnotes/models/note.model.dart';

part 'note.scheme.g.dart';

@collection

/// Note scheme
class LocalNote {
  /// Note scheme

  LocalNote();

  /// The `LocalNote.merge` factory method creates a new `LocalNote` object by merging the properties of
  /// a `Note` object.
  ///
  /// Args:
  ///   note (Note): The "note" parameter is an instance of the "Note" class.
  ///
  /// Returns:
  ///   The factory function is returning a new instance of the LocalNote class.
  factory LocalNote.merge(Note note) {
    return LocalNote()
      ..id = note.id
      ..modified = note.modified
      ..title = note.title
      ..category = note.category
      ..content = note.content
      ..favorite = note.favorite;
  }
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late int id;

  late int modified;
  late String title;
  @Index()
  late String content;
  late bool? favorite;
  late String? category;

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get contentWords =>
      content.replaceAll(RegExp('\n'), ' ').split(' ');

  @Index()
  List<String> get contentWordsAsList =>
      content.replaceAll(RegExp('\n'), ' ').split(' ');

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get titleWords => title.split(' ');

  @Index(type: IndexType.value, caseSensitive: false)
  List<String>? get categoryWords => category?.split(' ');

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'modified': modified,
      'title': title,
      'category': category,
      'content': content,
      'favorite': favorite
    };
  }
}
