import 'package:nextcloudnotes/models/note.model.dart';

/// The class for returning values of fetchNotes
class FetchAllNotesResponse {
  /// The class for returning values of fetchNotes

  FetchAllNotesResponse({required this.etag, this.notes});

  /// Declaring a final variable `notes` of type `List<Note>?`. The `?` indicates that the variable can be
  /// null. This variable is a property of the `FetchAllNotesResponse` class and can be accessed from
  /// instances of that class.
  final List<Note>? notes;

  /// `final String etag;` is declaring a final variable `etag` of type `String`. This variable is a
  /// property of the `FetchAllNotesResponse` class and can be accessed from instances of that class. It
  /// is used to store the ETag value returned by the server when fetching notes. ETag is a header value
  /// that is used for caching and conditional requests in HTTP.
  final String etag;
}
