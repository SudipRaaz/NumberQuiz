import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Message {
  static void flushBarErrorMessage(BuildContext context, String message) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        padding: const EdgeInsets.all(15),
        message: message,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
        borderRadius: BorderRadius.circular(30),
        flushbarPosition: FlushbarPosition.TOP,
        icon: const Icon(
          Icons.error_rounded,
          color: Colors.white,
        ),
      )..show(context),
    );
  }

  static void flutterToast(BuildContext context, String message) {
    Fluttertoast.showToast(
        msg: message, gravity: ToastGravity.TOP, backgroundColor: Colors.red);
  }
}
