import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:trakli/data/database/app_database.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(User user);
  Future<User?> getUser(int userId);
  Future<void> deleteUser();
}

@Injectable(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final AppDatabase database;

  AuthLocalDataSourceImpl(this.database);

  @override
  Future<void> saveUser(User user) async {
    await database.users.insertOne(user, mode: InsertMode.insertOrReplace);
  }

  @override
  Future<User?> getUser(int userId) async {
    final row = await (database.users.select()
          ..where((t) => t.id.equals(userId)))
        .getSingle();

    return row;
  }

  @override
  Future<void> deleteUser() async {
    await database.users.deleteAll();
  }
}
