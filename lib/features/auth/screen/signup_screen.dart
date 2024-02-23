// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';
import 'package:rentify/core/constants/constants.dart';
import 'package:rentify/core/utility.dart';
import 'package:rentify/features/auth/controller/auth_controller.dart';
import 'package:rentify/features/auth/screen/fingerprint_screen.dart';
import 'package:rentify/features/auth/screen/login_screen.dart';
import 'package:rentify/features/dashboard.dart/dashboard_screen.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import '../widget/rounded_textfield.dart';
import '../widget/terms_condition.dart';

class SignupScreen extends ConsumerStatefulWidget {
  static const routeName = '/signup-screen';
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phonenoController = TextEditingController();
  final cnicController = TextEditingController();

  File? profileImage;
  File? _pickedImage;
  String _recognizedText = '';
  final ImagePicker _picker = ImagePicker();
  final textRecognizer = TextRecognizer();

  Future<void> _pickImage() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
      _processImage();
    }
  }

  Future<bool> _processImage() async {
    if (_pickedImage == null) return false;

    final inputImage = InputImage.fromFile(_pickedImage!);

    final recognizedText = await textRecognizer.processImage(inputImage);
    String stringToCheck = cnicController.text;
    setState(() {
      _recognizedText = recognizedText.text;
    });

    bool containsString = _recognizedText.contains(stringToCheck);

    if (containsString) {
      // Proceed further if the recognized text contains the string
      // Add your further logic here
      print(
          "Recognized text contains the string '$stringToCheck'. Proceeding further...");
      return true;
    } else {
      // Handle the case where the recognized text does not contain the string
      print("Recognized text does not contain the string '$stringToCheck'.");
      return false;
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileImage = File(res.files.first.path!);
      });
    }
  }

  void signUpWithEmailAndPassword() async {
    if (fullNameController.text.isEmpty) {
      showSnackBar(context, 'Enter user name');
      return;
    }
    if (emailController.text.isEmpty) {
      showSnackBar(context, 'Enter your email');
      return;
    }
    if (phonenoController.text.isEmpty) {
      showSnackBar(context, 'Enter your phone no');
      return;
    }
    if (passwordController.text.isEmpty) {
      showSnackBar(context, 'Enter your password');
      return;
    }
    if (confirmPasswordController.text.isEmpty) {
      showSnackBar(context, 'confirm  password');
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      showSnackBar(context, 'confirm password not equal to password');
      return;
    }
    bool containsString = await _processImage();
    if (containsString == false) {
      showSnackBar(context, 'Your Cnic does not match');
      return;
    }
    if (profileImage == null) {
      showSnackBar(context, 'Choose profile image');
      return;
    }
    showSnackBar(context, 'SUBMITTED');

    ref.read(authControllerProvider.notifier).signUpWithEmailAndPassword(
          name: fullNameController.text,
          email: emailController.text,
          phone: phonenoController.text,
          imageFile: profileImage!,
          password: passwordController.text,
          context: context,
          cnic: cnicController.text,
        );
    showSnackBar(context, 'account Registered');
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (context) => const DashBoard(),
    // ));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80,
        title: Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            SizedBox(
              height: 75,
              width: 75,
              child: Image.asset(
                'assets/images/logo1.png',
                fit: BoxFit.fitHeight,
              ),
            ),
            Text('Signup', style: Constants.authText)
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(LoginScreen.routeName);
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                height: 30,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: Constants.buttonGredient,
                ),
                child: Text(
                  'Login',
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Rentify!',
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'Discover rentals and simplify renting',
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Create an account',
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                    onTap: selectProfileImage,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: const Color(0xff81A8A6),
                      backgroundImage:
                          const AssetImage('assets/images/profile.png'),
                      child: profileImage != null
                          ? ClipOval(
                              child: Image.file(
                                profileImage!,
                                fit: BoxFit.cover,
                                width: 90,
                                height: 90,
                              ),
                            )
                          : Container(),
                    )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full Name',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.raleway(fontWeight: FontWeight.w600),
                    ),
                    RoundedTextField(
                      controller: fullNameController,
                      name: 'Full Name',
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Text(
                      'Email',
                      style: GoogleFonts.raleway(fontWeight: FontWeight.w600),
                    ),
                    RoundedTextField(
                      controller: emailController,
                      name: 'Email',
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Text(
                      'Pasword',
                      style: GoogleFonts.raleway(fontWeight: FontWeight.w600),
                    ),
                    RoundedTextField(
                      controller: passwordController,
                      name: 'Password',
                      obsecure: true,
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Text(
                      'Confirm Pasword',
                      style: GoogleFonts.raleway(fontWeight: FontWeight.w600),
                    ),
                    RoundedTextField(
                      controller: confirmPasswordController,
                      name: 'Confirm Password',
                      obsecure: true,
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Text(
                      'Phone No',
                      style: GoogleFonts.raleway(fontWeight: FontWeight.w600),
                    ),
                    RoundedTextField(
                      controller: phonenoController,
                      name: 'Phone No.',
                    ),
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Text(
                      'Cnic',
                      style: GoogleFonts.raleway(fontWeight: FontWeight.w600),
                    ),
                    RoundedTextField(
                      controller: cnicController,
                      name: 'Cnic.',
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Text(
                      'Upload Cnic photo',
                      style: GoogleFonts.raleway(fontWeight: FontWeight.w600),
                    ),
                    InkWell(
                      onTap: () {
                        _pickImage();
                      },
                      child: Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey)),
                        child: _pickedImage != null
                            ? Image.file(
                                _pickedImage!,
                              )
                            : Center(child: Text('No image selected')),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    GestureDetector(
                      onTap: () {
                        signUpWithEmailAndPassword();
                      },
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phonenoController.dispose();
    textRecognizer.close();
  }
}
