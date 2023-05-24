import 'package:isar/isar.dart';
import 'package:nextcloudnotes/models/note.model.dart';

part 'note.scheme.g.dart';

@collection
class LocalNote {
  LocalNote();
  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late int id;

  late String etag;
  late bool readonly;
  late int modified;
  late String title;
  late String category;
  late String content;
  late bool favorite;

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

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "etag": etag,
      "readonly": readonly,
      "modified": modified,
      "title": title,
      "category": category,
      "content": content,
      "favorite": favorite
    };
  }
}
