import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

late Isar isarInstance;

Future<void> initDb(List<CollectionSchema<dynamic>> schemas) async {
  final dir = await getApplicationDocumentsDirectory();

  isarInstance = await Isar.open(schemas, directory: dir.path);
}
