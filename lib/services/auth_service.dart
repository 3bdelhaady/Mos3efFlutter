import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/user.dart';

class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Email/Password Registration
  Future<User> registerUser(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = User(
        email: userCredential.user?.email ?? email,
        password: password,
        authMethod: 'email',
      );

      // Save to SharedPreferences as backup
      await _saveUserLocal(user);

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseException(e);
    }
  }

  // Email/Password Login
  Future<User> loginUser(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = User(
        email: userCredential.user?.email ?? email,
        password: password,
        authMethod: 'email',
      );

      await _saveUserLocal(user);

      return user;
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw _handleFirebaseException(e);
    }
  }

  // Google Sign In
  Future<User> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw 'تم إلغاء تسجيل الدخول (Sign-in cancelled)';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // For google_sign_in 6.2.0+: accessToken might be null on some platforms
      // Firebase requires idToken for Google authentication
      final credential = firebase_auth.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken:
            googleAuth.accessToken, // Can be null, Firebase handles this
      );

      // Try to sign in/link
      try {
        final userCredential = await _firebaseAuth.signInWithCredential(
          credential,
        );

        final user = User(
          email: userCredential.user?.email ?? googleUser.email,
          password: null,
          authMethod: 'google',
        );

        await _saveUserLocal(user);
        return user;
      } on firebase_auth.FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // Email already exists with different auth method, link them
          return await _linkGoogleToExisting(credential, googleUser.email);
        }
        throw _handleFirebaseException(e);
      }
    } catch (e) {
      throw 'فشل تسجيل الدخول عبر Google: $e';
    }
  }

  // Link Google account to existing email/password account
  Future<User> _linkGoogleToExisting(
    firebase_auth.AuthCredential credential,
    String email,
  ) async {
    try {
      // Get the current user (if any)
      final currentUser = _firebaseAuth.currentUser;

      if (currentUser != null && currentUser.email == email) {
        // Current user matches, link directly
        await currentUser.linkWithCredential(credential);
        return User(
          email: currentUser.email ?? email,
          password: null,
          authMethod: 'google',
        );
      }

      // Otherwise, sign in with credential (creates new user or signs in existing)
      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      final user = User(
        email: userCredential.user?.email ?? email,
        password: null,
        authMethod: 'google',
      );

      await _saveUserLocal(user);
      return user;
    } catch (e) {
      throw 'فشل ربط حساب Google: $e';
    }
  }

  // Logout
  Future<void> logoutUser() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      await _clearUserLocal();
    } catch (e) {
      throw 'فشل تسجيل الخروج: $e';
    }
  }

  // Get current user
  Future<User?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;

      if (firebaseUser != null) {
        // Check if linked to Google
        final isGoogleLinked = firebaseUser.providerData.any(
          (provider) => provider.providerId == 'google.com',
        );

        return User(
          email: firebaseUser.email ?? '',
          password: null,
          authMethod: isGoogleLinked ? 'google' : 'email',
        );
      }

      // Try to get from SharedPreferences
      return await _getUserLocal();
    } catch (e) {
      return null;
    }
  }

  // Auth state stream
  Stream<firebase_auth.User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  // Helper: Save user to SharedPreferences
  Future<void> _saveUserLocal(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', _userToJson(user));
    } catch (e) {
      // Silent fail, Firebase is primary storage
    }
  }

  // Helper: Get user from SharedPreferences
  Future<User?> _getUserLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      if (userJson != null) {
        return _userFromJson(userJson);
      }
    } catch (e) {
      // Silent fail
    }
    return null;
  }

  // Helper: Clear user from SharedPreferences
  Future<void> _clearUserLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
    } catch (e) {
      // Silent fail
    }
  }

  // Helper: Convert User to JSON string
  String _userToJson(User user) {
    return '${user.email}|${user.password ?? 'null'}|${user.authMethod}';
  }

  // Helper: Convert JSON string to User
  User? _userFromJson(String json) {
    try {
      final parts = json.split('|');
      if (parts.length >= 3) {
        return User(
          email: parts[0],
          password: parts[1] == 'null' ? null : parts[1],
          authMethod: parts[2],
        );
      }
    } catch (e) {
      // Silent fail
    }
    return null;
  }

  // Helper: Map Firebase exceptions to user-friendly messages
  String _handleFirebaseException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'البريد الإلكتروني غير مسجل';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صحيح';
      case 'weak-password':
        return 'كلمة المرور ضعيفة - استخدم 6 أحرف على الأقل';
      case 'operation-not-allowed':
        return 'المصادقة معطلة حاليًا';
      case 'account-exists-with-different-credential':
        return 'حساب موجود بنفس البريد';
      default:
        return 'خطأ في المصادقة: ${e.message}';
    }
  }
}
