import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentify/core/constants/constants.dart';

import '../widget/terms_condition.dart';

class FingerprintScreen extends StatelessWidget {
  static const routeName = '/fingerprint-screen';
  const FingerprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: Constants.appBarGradient,
          ),
        ),
        title: Text(
          'Fingerprint Authentication',
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Add Fingerprint',
                style: GoogleFonts.raleway(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: height * 0.3,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/fingerprint.png',
                ),
              ),
              SizedBox(
                height: height * 0.2,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: Constants.buttonGredient,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next ',
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Image.asset(
                        'assets/images/next.png',
                        height: 20,
                        width: 20,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              const TermsAndConditions(),
            ],
          ),
        ),
      ),
    );
  }
}
