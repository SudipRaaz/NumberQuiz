import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smile_quiz/utilities/ErrorMessageContainer/message.dart';
import 'package:smile_quiz/view_model/services/Authentication_base.dart';

import 'firebase_abstract.dart';
import 'firestore.dart';

class Auth extends Authenticate {
  final _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChange => _firebaseAuth.idTokenChanges();

  @override
  Future createUserWithEmailAndPassword(BuildContext context, String email,
      String password, String name, int age) async {
    try {
      // try creating user with the provide email and password
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      // register user details on firebase cloudstore
      FirebaseBase obj = CloudStore();
      obj.registerUser(Auth().currentUser?.uid, name, email, age);
      // catch any firebase errors from firebase
    } on FirebaseAuthException catch (error) {
      Message.flutterToast(context, error.message.toString());
      // catch any error and display it to the user
    } catch (error) {
      Message.flutterToast(context, error.toString());
    }
  }

  @override
  Future signInWithEmailAndPassword(
      context, String email, String password) async {
    try {
      // sign in with email and password from firebase auth
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      // catch exceptios from firebase and display it to the users
    } on FirebaseAuthException catch (error) {
      Message.flutterToast(context, error.message.toString());
      // catch any exceptions occured and display
    } catch (error) {
      Message.flushBarErrorMessage(context, '$error+ 5555');
    }
  }

  @override
  // sign out from current auth account
  Future signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  passwordReset(BuildContext context, String email) async {
    try {
      // request for forget password and send password reset mail to user's mailbox
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      // ignore: use_build_context_synchronously
      Message.flutterToast(context, "Check your Mail Box (Spam)");
      // catch exception from firebase
    } on FirebaseAuthException catch (e) {
      Message.flutterToast(context, e.message.toString());
      // catch any exception
    } catch (error) {
      Message.flutterToast(context, error.toString());
    }
  }
}
