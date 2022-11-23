import 'package:flutter/material.dart';

abstract class Authenticate {
  Future signInWithEmailAndPassword(
      BuildContext context, String email, String password);

  Future createUserWithEmailAndPassword(BuildContext context, String email,
      String password, String name, int age);

  Future signOut();

  passwordReset(BuildContext context, String email);
}
