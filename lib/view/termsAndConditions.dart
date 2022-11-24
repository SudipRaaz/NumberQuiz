import 'package:flutter/material.dart';
import 'package:smile_quiz/resources/appcolors.dart';

class TermAndCondition extends StatelessWidget {
  const TermAndCondition({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        centerTitle: true,
        backgroundColor: AppColors.appBar_theme,
      ),
      body: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              paragraphHeading("Terms"),
              paragraph(
                  'o By registering and playing on this Website you agree to comply with the Terms and Conditions.'),
              paragraph(
                  'o This Website is restricted to individuals who are eighteen years of age and older. You cannot play under any circumstances if you are not at least eighteen years of age. The Company reserves the right to request proof of your age at any time and may cancel your account if such proof is not provided.'),
              paragraph(
                  'o You are only permitted to use the Website for your own personal entertainment and non-professional use.'),
              paragraphHeading("Account Cancellation"),
              paragraph(
                  'o The Company reserves the right to cancel your account for any reason whatsoever at any time without notice to you.'),
            ],
          )
        ],
      ),
    );
  }

  Widget paragraphHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12, top: 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 8, right: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
