import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smile_quiz/utilities/message.dart';
import 'package:smile_quiz/view_model/services/Authentication_base.dart';

class Auth extends Authenticate {
  final _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChange => _firebaseAuth.idTokenChanges();

  @override
  Future createUserWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  @override
  Future signInWithEmailAndPassword(
      context, String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      Message.flushBarErrorMessage(context, "${e.toString()}");
    }
  }

  @override
  Future signOut() async {
    await _firebaseAuth.signOut();
  }

  void setLocalUserToken(token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("token", '${token}');
  }

  Future<String> get getUserToken async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = await pref.getString('token') ?? '';
    return token;
  }
}
