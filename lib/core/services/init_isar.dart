import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

/// `late Isar isarInstance;` is declaring a variable named `isarInstance` of type `Isar` as a late
/// variable. A late variable is a variable that is not initialized when it is declared, but its
/// initialization is guaranteed to happen before it is used. In this case, `isarInstance` is
/// initialized in the `initDb` function before it is used in other parts of the code.
late Isar isarInstance;

/// This function initializes an Isar database with a list of collection schemas.
///
/// Args:
///   schemas (List<CollectionSchema<dynamic>>): The `schemas` parameter is a `List` of
/// `CollectionSchema` objects that define the schema of the collections that will be stored in the
/// database. Each `CollectionSchema` object represents a collection and contains information such as
/// the name of the collection, the types of objects that can be stored in
Future<void> initDb(List<CollectionSchema<dynamic>> schemas) async {
  final dir = await getApplicationDocumentsDirectory();

  isarInstance = await Isar.open(schemas, directory: dir.path);
}
