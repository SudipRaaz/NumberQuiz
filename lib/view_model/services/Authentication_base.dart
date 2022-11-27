// ignore: file_names
import 'package:flutter/material.dart';

abstract class Authenticate {
  // sign in with email and password method
  Future signInWithEmailAndPassword(
      BuildContext context, String email, String password);

  // create users with email and password
  Future createUserWithEmailAndPassword(BuildContext context, String email,
      String password, String name, int age);

  // signout method
  Future signOut();

  // password reset method
  passwordReset(BuildContext context, String email);
}
