import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/services/dio/init_dio.dart';
import 'package:nextcloudnotes/models/note.model.dart';

@lazySingleton
class NoteRepositories {
  NoteRepositories(this._dio);
  final DioService _dio;

  Future<List<Note>> fetchNotes() async {
    final response = await _dio.get("/index.php/apps/notes/api/v1/notes");

    List<Note> noteFromJson(List<dynamic> e) =>
        List<Note>.from(e.map((e) => Note.fromJson(e)));

    return noteFromJson(response.data);
  }

  Future<Note> fetchNote(int noteId) async {
    final response =
        await _dio.get("/index.php/apps/notes/api/v1/notes/$noteId");

    return Note.fromJson(response.data);
  }

  Future<bool> deleteNote(int noteId) async {
    final response =
        await _dio.delete("/index.php/apps/notes/api/v1/notes/$noteId");

    if (response?.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }

  Future<bool> updateNote(int noteId, Note note) async {
    final response = await _dio.put(
        "/index.php/apps/notes/api/v1/notes/$noteId", note.toJson());

    if (response?.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }
}
