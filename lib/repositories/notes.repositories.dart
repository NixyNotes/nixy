import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/services/dio/init_dio.dart';
import 'package:nextcloudnotes/models/note.model.dart';

@lazySingleton
class NoteRepositories {
  NoteRepositories(this._dio);
  final DioService _dio;

  Future<Note> fetchNote(int noteId) async {
    final response =
        await _dio.get("/index.php/apps/notes/api/v1/notes/$noteId");

    return Note.fromJson(response!.data);
  }
}
