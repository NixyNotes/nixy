import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:nextcloudnotes/core/models/user.model.dart';
import 'package:nextcloudnotes/core/services/init_isar.dart';

@injectable
class AuthStorage {
  saveUser(User user) async {
    isarInstance.writeTxn(() async {
      await isarInstance.users.put(user);
    });
  }

  Future<List<User>> getUsers() async {
    return await isarInstance.users.where().findAll();
  }

  Future<int> hasUser() async {
    return isarInstance.users;
  }

  Future<void> deleteAll() async {
    isarInstance.writeTxn(() async {
      await isarInstance.users.clear();
    });
  }
}
