import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/adapters/base.adapter.dart';
import 'package:nextcloudnotes/core/adapters/init_adapters.dart';
import 'package:nextcloudnotes/core/services/dio/init_dio.dart';
import 'package:nextcloudnotes/models/note.model.dart';

@lazySingleton
class MoteAdapter implements BaseAdapter {
  MoteAdapter(this._dioService, this._adapter);
  final DioService _dioService;
  final Adapter _adapter;

  String get uri => _adapter.currentServerUri;

  @override
  Future<Note> createNewNote({required NewNote data}) {
    // TODO: implement createNewNote
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteNote({required int id}) {
    print('deleting from mote');
    // TODO: implement deleteNote
    throw UnimplementedError();
  }

  @override
  Future<Note> fetchNote({required int id}) {
    // TODO: implement fetchNote
    throw UnimplementedError();
  }

  @override
  Future<List<Note>> fetchNotes() async {
    final response = await _dioService.get('$uri/notes');

    List<Note> noteFromJson(List<dynamic> e) => List<Note>.from(
          e.map(
            (ee) => Note(
              category: '',
              content: ee['content'] as String,
              favorite: false,
              id: ee['id'] as int,
              modified: DateTime.parse(ee['updated_at'] as String)
                  .millisecondsSinceEpoch,
              title: ee['title'] as String,
            ),
          ),
        );

    return noteFromJson(response.data['data'] as List<dynamic>);
  }

  @override
  Future<Note> fetchNotesByCategory({required String categoryName}) {
    // TODO: implement fetchNotesByCategory
    throw UnimplementedError();
  }

  @override
  Future<Note> updateNote({required int id, required Note data}) async {
    try {
      final response = await _dioService.put('$uri/$id', data.toJson());

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
