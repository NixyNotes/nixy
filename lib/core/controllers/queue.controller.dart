// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:nextcloudnotes/models/note.model.dart';
import 'package:nextcloudnotes/repositories/notes.repositories.dart';

enum QueueActionTypes {
  DELETE,
  UPDATE,
  ADD,
}

class QueueAction {
  QueueAction({required this.type, required this.note});

  final QueueActionTypes type;
  final Note note;
}

@lazySingleton
class QueueController {
  QueueController(this._noteRepositories);

  StreamController<QueueAction> queue = StreamController.broadcast();
  final NoteRepositories _noteRepositories;

  init() {
    queue.stream.listen((event) async {
      switch (event.type) {
        case QueueActionTypes.ADD:
          break;
        case QueueActionTypes.UPDATE:
          await _noteRepositories.updateNote(event.note.id, event.note);
          break;
        case QueueActionTypes.DELETE:
          break;
      }
    });
  }
}
