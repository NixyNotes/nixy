import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/services/dio/init_dio.dart';
import 'package:nextcloudnotes/models/note.model.dart';

@lazySingleton
class NoteRepositories {
  NoteRepositories(this._dio);
  final DioService _dio;

  String get _apiUrl => "/index.php/apps/notes/api/v1/notes";

  Future<List<Note>> fetchNotes() async {
    final response = await _dio.get(_apiUrl);

    List<Note> noteFromJson(List<dynamic> e) =>
        List<Note>.from(e.map((e) => Note.fromJson(e)));

    return noteFromJson(response.data);
  }

  Future<List<Note>> fetchNotesByCategory(String categoryName) async {
    final response = await _dio.get("$_apiUrl?category=$categoryName");

    List<Note> noteFromJson(List<dynamic> e) =>
        List<Note>.from(e.map((e) => Note.fromJson(e)));

    return noteFromJson(response.data);
  }

  Future<Note> fetchNote(int noteId) async {
    final response = await _dio.get("$_apiUrl/$noteId");

    return Note.fromJson(response.data);
  }

  Future<bool> deleteNote(int noteId) async {
    final response = await _dio.delete("$_apiUrl/$noteId");

    if (response?.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }

  Future<bool> updateNote(int noteId, Note note) async {
    final response = await _dio.put("$_apiUrl/$noteId", note.toJson());

    if (response?.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }

  Future<Note?> createNewNote(NewNote note) async {
    try {
      final response = await _dio.post(_apiUrl, note.toJson());

      return Note.fromJson(response.data);
    } on DioError {
      rethrow;
    }
  }
}
