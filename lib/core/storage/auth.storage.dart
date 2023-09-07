import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:nextcloudnotes/core/scheme/user.scheme.dart';
import 'package:nextcloudnotes/core/services/init_isar.dart';

/// The AuthStorage class provides methods for saving, retrieving, and deleting user data using Isar
/// database in Dart.
@lazySingleton
class AuthStorage {
  /// The function saves a user object to an Isar database instance.
  ///
  /// Args:
  ///   user (User): The parameter "user" is an instance of the "User" class that contains information
  /// about a user. This method saves the user object to a database using Isar.
  Future<void> saveUser(User user) async {
    return isarInstance.writeTxn(() async {
      await isarInstance.users.put(user);
    });
  }

  /// This function returns a Future that resolves to a list of all users stored in the Isar database.
  ///
  /// Returns:
  ///   A `Future` object that will eventually contain a `List` of `User` objects. The `List` will be
  /// retrieved from the `users` table in the Isar database using a query that selects all rows.
  Future<List<User>> getUsers() {
    return isarInstance.users.where().findAll();
  }

  /// The function checks if there are any users in the Isar database and returns a boolean value
  /// indicating the result.
  ///
  /// Returns:
  ///   A boolean value indicating whether there are any users in the Isar database or not.
  Future<bool> hasUsers() async {
    final usersCount = await isarInstance.users.count();

    return usersCount > 0;
  }

  /// The function deletes all users from the Isar database.
  Future<void> deleteAll() async {
    await isarInstance.writeTxn(() async {
      await isarInstance.users.clear();
    });
  }

  /// This function deletes a user account from a database using Isar.
  ///
  /// Args:
  ///   accountId (int): The accountId parameter is an integer that represents the unique identifier of
  /// the account that needs to be deleted.
  Future<void> deleteAccount(int accountId) async {
    await isarInstance.writeTxn(() async {
      await isarInstance.users.where().idEqualTo(accountId).deleteAll();
    });
  }
}
