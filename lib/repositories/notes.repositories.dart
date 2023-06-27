import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/services/dio/init_dio.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nextcloudnotes/models/notes_response.model.dart';

@lazySingleton

/// The NoteRepositories class contains methods for fetching, deleting, updating, and creating notes
/// using an API endpoint.
class NoteRepositories {
  /// The NoteRepositories class contains methods for fetching, deleting, updating, and creating notes
  /// using an API endpoint.
  NoteRepositories(this._dio);
  final DioService _dio;

  String get _apiUrl => '/index.php/apps/notes/api/v1/notes';

  /// This function fetches notes from an API endpoint and returns them along with an etag value for
  /// caching purposes.
  ///
  /// Args:
  ///   etag (String): The etag parameter is an optional string that represents the entity tag of the
  /// resource being requested. It is used to check if the resource has been modified since the last time
  /// it was accessed. If the resource has not been modified, the server returns a 304 Not Modified
  /// status code and the client can
  ///
  /// Returns:
  ///   The `fetchNotes` function returns a `Future` that resolves to a `FetchAllNotesResponse` object.
  /// If the HTTP response status code is not `HttpStatus.notModified`, the `FetchAllNotesResponse`
  /// object will contain an `etag` string and a list of `Note` objects. If the status code is
  /// `HttpStatus.notModified`, the `FetchAllNotesResponse` object will only
  Future<FetchAllNotesResponse> fetchNotes([String? etag]) async {
    final headers = etag != null ? {'If-None-Match': etag} : null;

    final response = await _dio.get(
      _apiUrl,
      headers,
    );

    if (response.statusCode != HttpStatus.notModified) {
      List<Note> noteFromJson(List<dynamic> e) => List<Note>.from(
            e.map((ee) => Note.fromJson(ee as Map<String, dynamic>)),
          );

      return FetchAllNotesResponse(
        etag: response.headers.value('etag')!,
        notes: noteFromJson(response.data as List),
      );
    }
    return FetchAllNotesResponse(
      etag: response.headers.value('etag')!,
    );
  }

  /// This function fetches all notes belonging to a specific category and returns them along with an
  /// etag value.
  ///
  /// Args:
  ///   categoryName (String): A string representing the name of the category for which notes are to be
  /// fetched.
  ///   etag (String): etag is an optional parameter that represents the entity tag of the previously
  /// fetched response. It is used to check if the response has been modified since the last fetch. If
  /// the response has not been modified, the server can return a 304 Not Modified status code, and the
  /// client can use the cached response
  ///
  /// Returns:
  ///   A `Future` of `FetchAllNotesResponse` object is being returned.
  Future<FetchAllNotesResponse> fetchNotesByCategory(
    String categoryName, [
    String? etag,
  ]) async {
    final headers = etag != null ? {'If-None-Match': etag} : null;

    final response = await _dio.get('$_apiUrl?category=$categoryName', headers);

    List<Note> noteFromJson(List<dynamic> e) => List<Note>.from(
          e.map((ee) => Note.fromJson(ee as Map<String, dynamic>)),
        );

    final remoteEtag = response.headers.value('etag');

    return FetchAllNotesResponse(
      etag: remoteEtag!,
      notes: noteFromJson(response.data as List<dynamic>),
    );
  }

  /// This function fetches a note with a specific ID from an API and returns it as a Note object.
  ///
  /// Args:
  ///   noteId (int): The ID of the note that needs to be fetched from the API.
  ///
  /// Returns:
  ///   A `Future` object that will eventually resolve to a `Note` object. The `fetchNote` function
  /// retrieves a note with the specified `noteId` from an API endpoint using the `_dio` HTTP client, and
  /// then converts the response data into a `Note` object using the `fromJson` method.

  Future<Note> fetchNote(int noteId) async {
    final response = await _dio.get('$_apiUrl/$noteId');

    return Note.fromJson(response.data as Map<String, dynamic>);
  }

  /// This function sends a DELETE request to a specified API endpoint to delete a note with a given ID
  /// and returns a boolean indicating whether the request was successful.
  ///
  /// Args:
  ///   noteId (int): The ID of the note that needs to be deleted.
  ///
  /// Returns:
  ///   a `Future<bool>` value. It returns `true` if the HTTP response status code is `HttpStatus.ok`
  /// (which is equivalent to 200), indicating that the note with the specified ID was successfully
  /// deleted. Otherwise, it returns `false`.
  Future<bool> deleteNote(int noteId) async {
    final response = await _dio.delete('$_apiUrl/$noteId');

    if (response?.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }

  /// This function updates a note with the given ID and returns a boolean indicating whether the update
  /// was successful or not.
  ///
  /// Args:
  ///   noteId (int): The ID of the note that needs to be updated.
  ///   note (Note): The `note` parameter is an instance of the `Note` class, which contains the data to
  /// be updated for a particular note. It is passed as an argument to the `updateNote` method. The
  /// `toJson()` method is called on the `note` object to convert it to a JSON
  ///
  /// Returns:
  ///   A `Future<bool>` is being returned. The method updates a note with the given `noteId` by sending a
  /// PUT request to the API endpoint with the updated note data in JSON format. If the response status
  /// code is 200 (OK), the method returns `true`, otherwise it returns `false`.
  Future<bool> updateNote(int noteId, Note note) async {
    final response = await _dio.put('$_apiUrl/$noteId', note.toJson());

    if (response?.statusCode == HttpStatus.ok) {
      return true;
    }

    return false;
  }

  /// This function sends a POST request to create a new note and returns the created note as a Future.
  ///
  /// Args:
  ///   note (NewNote): The `note` parameter is an instance of the `NewNote` class, which contains the
  /// data for creating a new note. It is passed as an argument to the `createNewNote` method and is used
  /// to create a JSON object that is sent in the request body to the API endpoint.
  ///
  /// Returns:
  ///   A `Future` object that will eventually resolve to a `Note` object or `null` if the response data
  /// is not in the expected format.
  Future<Note?> createNewNote(NewNote note) async {
    try {
      final response = await _dio.post(_apiUrl, note.toJson());

      return Note.fromJson(response.data as Map<String, dynamic>);
    } on DioError {
      rethrow;
    }
  }
}
