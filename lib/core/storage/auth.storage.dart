import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:nextcloudnotes/core/models/user.model.dart';
import 'package:nextcloudnotes/core/services/init_isar.dart';

@injectable
class AuthStorage {
  saveUser(User user) {
    isarInstance.writeTxn(() async {
      await isarInstance.users.put(user);
    });
  }

  Future<List<User>> getUsers() {
    return isarInstance.users.where().findAll();
  }

  Future<bool> hasUsers() async {
    final usersCount = await isarInstance.users.count();

    return usersCount > 0;
  }

  Future<void> deleteAll() async {
    isarInstance.writeTxn(() async {
      await isarInstance.users.clear();
    });
  }

  Future<void> deleteAccount(int accountId) async {
    isarInstance.writeTxn(() async {
      await isarInstance.users.where().idEqualTo(accountId).deleteAll();
    });
  }
}
