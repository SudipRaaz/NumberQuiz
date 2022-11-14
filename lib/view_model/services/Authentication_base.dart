import 'package:flutter/material.dart';

abstract class Authenticate {
  Future signInWithEmailAndPassword(
      BuildContext context, String email, String password);

  Future createUserWithEmailAndPassword(
      BuildContext context, String email, String password);

  Future signOut();
}
