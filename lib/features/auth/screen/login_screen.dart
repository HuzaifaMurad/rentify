import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentify/core/constants/constants.dart';
import 'package:rentify/features/auth/controller/auth_controller.dart';
import 'package:rentify/features/auth/screen/signup_screen.dart';
import 'package:rentify/features/auth/widget/login_icon.dart';
import 'package:rentify/features/auth/widget/rounded_textfield.dart';

import '../widget/terms_condition.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signInwithGmail() {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  void loginWIthEmailAndPassword(String email, String password) {
    ref
        .read(authControllerProvider.notifier)
        .loginWithEmailAndPassword(email, password, context);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: height * 0.18,
                    width: width * 0.4,
                    child: Image.asset(
                      Constants.logo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Text(
                  'RENTIFY',
                  style: Constants.titleRentify,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Text('Login', style: Constants.authText),
                SizedBox(
                  height: height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        //nav to signup screen
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ));
                      },
                      child: Text(
                        'Create an account, ',
                        style: GoogleFonts.raleway(
                            color: Colors.blue, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Text(
                      'hold all your rental data ',
                      style: GoogleFonts.raleway(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Text(
                  'in one secure place !',
                  style: GoogleFonts.raleway(fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: height * 0.01,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 40,
                    ),
                    Text(
                      'Login With Google ',
                      style: GoogleFonts.raleway(
                          color: Colors.blue, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    LoginIcon(
                      icon: 'assets/images/google.png',
                      ontap: () {
                        signInwithGmail();
                      },
                    ),
                    // LoginIcon(
                    //   icon: 'assets/images/apple.png',
                    //   ontap: () {},
                    // ),
                    // LoginIcon(
                    //   icon: 'assets/images/logo.png',
                    //   ontap: () {},
                    // ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: GoogleFonts.raleway(fontWeight: FontWeight.w600),
                    ),
                    RoundedTextField(
                        controller: emailController, name: 'Email'),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Text(
                      'Pasword',
                      style: GoogleFonts.raleway(fontWeight: FontWeight.w600),
                    ),
                    RoundedTextField(
                        controller: passwordController, name: 'Password'),
                  ],
                ),
                SizedBox(
                  height: height * 0.09,
                ),
                InkWell(
                  onTap: () {
                    loginWIthEmailAndPassword(
                        emailController.text, passwordController.text);
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: Constants.buttonGredient,
                    ),
                    child: Text(
                      'Login',
                      style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
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
      ),
    );
  }
}
