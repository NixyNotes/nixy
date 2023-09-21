import 'package:diffutil_dart/diffutil.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/adapters/init_adapters.dart';
import 'package:nextcloudnotes/core/services/log.service.dart';
import 'package:nextcloudnotes/core/storage/note.storage.dart';
import 'package:nextcloudnotes/models/note.model.dart';

class _DataObjectListDiff extends ListDiffDelegate<Note> {
  _DataObjectListDiff(super.oldList, super.newList);

  @override
  bool areContentsTheSame(int oldItemPosition, int newItemPosition) {
    return equalityChecker(oldList[oldItemPosition], newList[newItemPosition]);
  }

  @override
  bool areItemsTheSame(int oldItemPosition, int newItemPosition) {
    return oldList[oldItemPosition].title == newList[newItemPosition].title ||
        oldList[oldItemPosition].content == newList[newItemPosition].content;
  }
}

@lazySingleton
class SyncService {
  SyncService(this._adapter, this._noteStorage, this._logService);

  final Adapter _adapter;
  final NoteStorage _noteStorage;
  final LogService _logService;

  Observable<bool> isSyncing = Observable(false);

  Future<void> init() async {
    _adapter.currentAdapter.observe((p0) {
      //FIXME: seconds 3
      Future.delayed(Duration.zero, _calculateDiff);
    });
  }

  Future<Iterable<DataDiffUpdate<Note>>?> _calculateDiff() async {
    final localNotes = await _fetchLocalNotes();
    final remoteNotes = await _fetchRemoteNotes();

    if (localNotes != null && remoteNotes != null) {
      try {
        isSyncing.value = true;

        final s = calculateDiff<Note>(
          _DataObjectListDiff(remoteNotes, localNotes),
          detectMoves: true,
        );

        final diffrences = s.getUpdatesWithData();

        for (final diffrence in diffrences) {
          await diffrence.when(
            remove: (position, data) async {
              await _adapter.currentAdapter.value?.deleteNote(id: data.id);

              _logService.logger.i(
                'SYNC: Removing ${data.title} from local notes, as it is removed.',
              );
            },
            change: (pos, oldData, newData) async {
              await _adapter.currentAdapter.value
                  ?.updateNote(id: oldData.id, data: newData);
              _logService.logger.i(
                'SYNC: Changing ${oldData.title} to ${newData.title}',
              );
              _noteStorage.saveNote(newData);
            },
            insert: (position, data) async {
              await _adapter.currentAdapter.value
                  ?.createNewNote(data: NewNote.fromJson(data.toJson()));
              _logService.logger.i(
                'SYNC: Inserted ${data.title}',
              );
            },
            move: (pos, position, data) {},
          );
        }
      } catch (e) {
        _logService.logger.e(
          e,
        );
        return null;
      } finally {
        isSyncing.value = false;
      }
    }
    return null;
  }

  Future<List<Note>?> _fetchRemoteNotes() async {
    try {
      return await _adapter.currentAdapter.value?.fetchNotes();
    } catch (e) {
      _logService.logger.e(e);
      return null;
    }
  }

  Future<List<Note>?> _fetchLocalNotes() async {
    try {
      return _noteStorage.getAllNotes();
    } catch (e) {
      return null;
    }
  }
}
