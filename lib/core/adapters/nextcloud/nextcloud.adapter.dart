import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/adapters/base.adapter.dart';
import 'package:nextcloudnotes/core/services/dio/init_dio.dart';
import 'package:nextcloudnotes/models/note.model.dart';

@lazySingleton
class NextcloudAdapter implements BaseAdapter {
  NextcloudAdapter(this._dioService);

  final DioService _dioService;
  String get _apiUrl => '/index.php/apps/notes/api/v1/notes';

  @override
  Future<Note> createNewNote({required NewNote data}) async {
    try {
      final response = await _dioService.post(_apiUrl, data.toJson());

      return Note.fromJson(response.data as Map<String, dynamic>);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<bool> deleteNote({required int id}) {
    print('delete from nextcloud');

    throw UnimplementedError();
  }

  @override
  Future<Note> fetchNote({required int id}) {
    // TODO: implement fetchNote
    throw UnimplementedError();
  }

  @override
  Future<List<Note>> fetchNotes() async {
    try {
      final response = await _dioService.get(_apiUrl);

      List<Note> noteFromJson(List<dynamic> e) => List<Note>.from(
            e.map((ee) => Note.fromJson(ee as Map<String, dynamic>)),
          );

      return noteFromJson(response.data as List<dynamic>);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<Note> fetchNotesByCategory({required String categoryName}) {
    // TODO: implement fetchNotesByCategory
    throw UnimplementedError();
  }

  @override
  Future<Note> updateNote({required int id, required Note data}) async {
    try {
      final response = await _dioService.put('$_apiUrl/$id', data.toJson());

      return data;
    } on DioError {
      rethrow;
    }
  }

  @override
  Note convertToGeneralModel() {
    // TODO: implement convertToGeneralModel
    throw UnimplementedError();
  }
}
