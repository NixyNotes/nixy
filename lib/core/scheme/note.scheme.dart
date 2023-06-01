// ignore_for_file: public_member_api_docs

import 'package:isar/isar.dart';
import 'package:nextcloudnotes/models/note.model.dart';

part 'note.scheme.g.dart';

@collection

/// Note scheme
class LocalNote {
  /// Note scheme

  LocalNote();

  /// The function creates a new LocalNote object by merging the properties of a Note object.
  ///
  /// Args:
  ///   note (Note): `note` is an instance of the `Note` class, which contains properties such as `id`,
  /// `etag`, `readonly`, `modified`, `title`, `category`, `content`, and `favorite`. These properties
  /// represent the attributes of a note object. The `merge` method in the
  ///
  /// Returns:
  ///   A `LocalNote` object is being returned.
  factory LocalNote.merge(Note note) {
    return LocalNote()
      ..id = note.id
      ..etag = note.etag
      ..readonly = note.readonly
      ..modified = note.modified
      ..title = note.title
      ..category = note.category
      ..content = note.content
      ..favorite = note.favorite;
  }
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late int id;

  late String etag;
  late bool readonly;
  late int modified;
  late String title;
  @Index()
  late String category;
  late String content;
  late bool favorite;

  @Index(caseSensitive: false)
  List<String> get contentWords =>
      content.replaceAll(RegExp("/\n/g", multiLine: true), " ").split(' ');

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get titleWords => title.split(' ');

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get categoryWords => category.split(' ');

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'etag': etag,
      'readonly': readonly,
      'modified': modified,
      'title': title,
      'category': category,
      'content': content,
      'favorite': favorite
    };
  }
}
