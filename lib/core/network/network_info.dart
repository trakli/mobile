import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

@Injectable(as: NetworkInfo)
class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl();

  late Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    final connectivityResulst = await _connectivity.checkConnectivity();
    if (connectivityResulst == ConnectivityResult.none) {
      return false;
    } else {
      return true;
    }
  }

  @postConstruct
  void init() {
    _connectivity = Connectivity();
  }
}
