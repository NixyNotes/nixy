import 'package:nextcloudnotes/models/note.model.dart';

/// The class for returning values of fetchNotes
class FetchNoteResponse {
  /// The class for returning values of fetchNotes

  FetchNoteResponse({required this.etag, this.note});

  /// `final Note? notes;` is declaring a final variable `notes` of type `Note?` (nullable Note). This
  /// variable is a property of the `FetchNoteResponse` class and can be accessed from instances of that
  /// class. It is used to store the fetched note data returned by the server. The `?` indicates that the
  /// `notes` variable can be null.
  final Note? note;

  /// `final String etag;` is declaring a final variable `etag` of type `String`. This variable is also a
  /// property of the `FetchNoteResponse` class and can be accessed from instances of that class. It is
  /// used to store the ETag value returned by the server, which is a unique identifier for the version of
  /// the resource being fetched. This value can be used for caching purposes to avoid unnecessary network
  /// requests.
  final String etag;
}
