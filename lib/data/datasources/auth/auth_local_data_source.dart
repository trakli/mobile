import 'package:injectable/injectable.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser();
}

@Injectable(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl();

  @override
  Future<void> saveUser() async {}
}
