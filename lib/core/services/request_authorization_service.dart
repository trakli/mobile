import 'package:injectable/injectable.dart';
import 'package:trakli/core/services/auth_service.dart';
import 'package:drift_sync_core/drift_sync_core.dart';

/// Service to control when sync operations can be performed based on authentication status
@Injectable(as: RequestAuthorizationService)
class RequestAuthorizationServiceImpl implements RequestAuthorizationService {
  final AuthService _authService;

  RequestAuthorizationServiceImpl(this._authService);

  /// Check if sync operations are allowed
  @override
  Future<bool> canSync() async {
    return await _authService.isAuthenticated();
  }
}
