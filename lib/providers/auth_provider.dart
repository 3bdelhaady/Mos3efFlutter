import 'package:flutter/foundation.dart';
import '/models/user.dart';
import '/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  User? _user;
  bool _isLoading = false;
  String _errorMessage = '';

  AuthProvider(this._authService) {
    _checkAuthState();
  }

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  // Check current auth state
  void _checkAuthState() {
    _authService.authStateChanges.listen((firebaseUser) {
      if (firebaseUser != null) {
        _user = User(
          email: firebaseUser.email ?? '',
          password: null,
          authMethod:
              firebaseUser.providerData.any((p) => p.providerId == 'google.com')
              ? 'google'
              : 'email',
        );
      } else {
        _user = null;
      }
      notifyListeners();
    });
  }

  // Register with email/password
  Future<void> register(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _user = await _authService.registerUser(email, password);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _user = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Login with email/password
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _user = await _authService.loginUser(email, password);
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _user = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Login with Google
  Future<void> loginWithGoogle() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _user = await _authService.signInWithGoogle();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
      _user = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _authService.logoutUser();
      _user = null;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
