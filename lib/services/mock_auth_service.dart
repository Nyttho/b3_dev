
class MockAuthService {
  // Mock user data
  String? _userId;
  String? _userEmail;
  bool _isAuthenticated = false;

  // Check if user is authenticated
  bool get isAuthenticated => _isAuthenticated;

  // Get current user ID
  String? get currentUserId => _userId;

  // Get current user email
  String? get currentUserEmail => _userEmail;

  // Sign in with email and password
  Future<bool> signInWithPassword({required String email, required String password}) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simple mock authentication - accept any email with password "password"
    if (password == "password") {
      _userId = "mock-user-${DateTime.now().millisecondsSinceEpoch}";
      _userEmail = email;
      _isAuthenticated = true;
      return true;
    }

    return false;
  }

  // Sign up with email and password
  Future<bool> signUp({required String email, required String password}) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Always succeed for mock
    _userId = "mock-user-${DateTime.now().millisecondsSinceEpoch}";
    _userEmail = email;
    _isAuthenticated = true;
    return true;
  }

  // Sign out
  Future<void> signOut() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    _userId = null;
    _userEmail = null;
    _isAuthenticated = false;
  }
}

