import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/core/services/dio/init_dio.dart';
import 'package:nextcloudnotes/models/note.model.dart';

@lazySingleton

/// The NoteRepositories class contains methods for fetching, deleting, updating, and creating notes
/// using an API endpoint.
class NoteRepositories {
  NoteRepositories(this._dio);
  final DioService _dio;

  String get _apiUrl => '/index.php/apps/notes/api/v1/notes';

  /// This function fetches a list of notes from an API and converts the response data into a list of Note
  /// objects.
  ///
  /// Returns:
  ///   The `fetchNotes()` function is returning a `Future` that resolves to a `List` of `Note` objects.
  /// The `Note` objects are created by parsing the JSON data returned from the API using the
  /// `Note.fromJson()` method.
  Future<List<Note>> fetchNotes() async {
    final response = await _dio.get(_apiUrl);

    List<Note> noteFromJson(List<dynamic> e) => List<Note>.from(
          e.map((ee) => Note.fromJson(ee as Map<String, dynamic>)),
        );

    return noteFromJson(response.data as List);
  }

  /// This function fetches a list of notes filtered by a specific category name.
  ///
  /// Args:
  ///   categoryName (String): The category name is a string parameter that is used to filter notes by
  /// their category. The function fetches a list of notes from an API endpoint based on the provided
  /// category name.
  ///
  /// Returns:
  ///   A `Future` that resolves to a `List` of `Note` objects fetched from the API based on the provided
  /// `categoryName`.
  Future<List<Note>> fetchNotesByCategory(String categoryName) async {
    final response = await _dio.get('$_apiUrl?category=$categoryName');

    List<Note> noteFromJson(List<dynamic> e) => List<Note>.from(
          e.map((ee) => Note.fromJson(ee as Map<String, dynamic>)),
        );

    return noteFromJson(response.data as List<dynamic>);
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
