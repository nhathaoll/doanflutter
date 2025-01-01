import '../models/user.dart';

class SessionManager {
  static final SessionManager _instance = SessionManager._internal();
  factory SessionManager() => _instance;
  SessionManager._internal();

  User? _currentUser;

  User? get currentUser => _currentUser;

  void login(User user) {
    _currentUser = user;
  }

  void logout() {
    _currentUser = null;
  }

  bool get isLoggedIn => _currentUser != null;
}
