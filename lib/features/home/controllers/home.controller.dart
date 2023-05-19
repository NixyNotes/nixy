import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:nextcloudnotes/core/services/di/di.dart';
import 'package:nextcloudnotes/core/services/dio/init_dio.dart';
import 'package:nextcloudnotes/models/note.model.dart';
part 'home.controller.g.dart';

@lazySingleton
class HomeViewController = _HomeViewControllerBase with _$HomeViewController;

abstract class _HomeViewControllerBase with Store {
  @observable
  List<Note> notes = [];

  fetchCurrentUser() async {
    final dio = getIt<DioService>();

    final sa = await dio.get("/index.php/apps/notes/api/v1/notes");

    List<Note> noteFromJson(List<dynamic> e) =>
        List<Note>.from(e.map((e) => Note.fromJson(e)));

    notes = noteFromJson(sa!.data);
  }
}
