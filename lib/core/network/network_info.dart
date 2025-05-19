import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

@Injectable(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl();

  late InternetConnection _internetConnection;

  @override
  Future<bool> get isConnected async {
    final connectivityResulst = await _internetConnection.hasInternetAccess;
    if (connectivityResulst == false) {
      return false;
    } else {
      return true;
    }
  }

  @postConstruct
  void init() {
    _internetConnection = InternetConnection();
  }
}
