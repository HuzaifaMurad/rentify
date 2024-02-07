import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentify/core/constants/constants.dart';

import '../features/auth/controller/auth_controller.dart';

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Add your authentication logic here
    if (username == "admin" && password == "password") {
      // Navigate to admin dashboard or perform other actions
      print("Admin logged in successfully!");
    } else {
      // Show an error message or perform other actions
      print("Invalid username or password");
      _animationController.forward(from: 0);
    }
  }

  void loginWIthEmailAndPassword(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      _animationController.forward(from: 0);
      return;
    }
    ref
        .read(authControllerProvider.notifier)
        .loginWithEmailAndPassword(email, password, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Admin Login'),
      // ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0.sp),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Text(
                'RENTIFY',
                style: Constants.titleRentify,
              ),
              SizedBox(
                height: 15.h,
              ),
              Text('Admin Login', style: Constants.authText),
              Container(
                padding: EdgeInsets.all(
                  20.sp,
                ),
                decoration: BoxDecoration(
                  gradient: Constants.appBarGradient,
                  borderRadius: BorderRadius.all(
                    Radius.circular(40.sp),
                  ),
                ),
                width: 500.w,
                child: Column(
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Email ',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ScaleTransition(
                      scale: Tween<double>(begin: 0.0, end: 1.0)
                          .animate(_animationController),
                      child: const Text(
                        'Invalid username or password',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              InkWell(
                onTap: () {
                  // _login();
                  loginWIthEmailAndPassword(
                      _usernameController.text, _passwordController.text);
                },
                child: Container(
                  height: 50.h,
                  width: 300.w,
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
            ],
          ),
        ),
      ),
    );
  }
}
