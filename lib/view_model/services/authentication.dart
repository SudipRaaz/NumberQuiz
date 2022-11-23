import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smile_quiz/utilities/message.dart';
import 'package:smile_quiz/view_model/services/Authentication_base.dart';

class Auth extends Authenticate {
  final _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChange => _firebaseAuth.idTokenChanges();

  @override
  Future createUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (error) {
      Message.flutterToast(context, error.message.toString());
    } catch (error) {
      Message.flushBarErrorMessage(context, error.toString());
    }
  }

  @override
  Future signInWithEmailAndPassword(
      context, String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(
          msg: error.message.toString(),
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.redAccent);
    } catch (error) {
      Message.flushBarErrorMessage(context, '${error}+ 5555');
    }
  }

  @override
  Future signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  passwordReset(BuildContext context, String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      // ignore: use_build_context_synchronously
      Message.flutterToast(context, "Check your Mail Box (Spam)");
    } on FirebaseAuthException catch (e) {
      Message.flutterToast(context, e.message.toString());
    } catch (error) {
      Message.flutterToast(context, error.toString());
    }
  }
}
