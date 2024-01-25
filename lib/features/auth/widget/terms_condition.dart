import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        text: 'By continuing, you indicate that you agree to our ',
        style: TextStyle(color: Colors.black),
        children: <TextSpan>[
          TextSpan(
            text: 'terms',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          TextSpan(
            text: ' and ',
          ),
          TextSpan(
            text: 'conditions',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
