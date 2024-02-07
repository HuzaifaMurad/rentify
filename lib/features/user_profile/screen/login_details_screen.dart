import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentify/core/constants/constants.dart';
import 'package:rentify/features/user_profile/widgets/profile_editfield.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';

import '../../../core/utility.dart';
import '../../../models/review.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/user_profile_controller.dart';

class LoginDetailsUpdate extends ConsumerStatefulWidget {
  const LoginDetailsUpdate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoginDetailsUpdateState();
}

class _LoginDetailsUpdateState extends ConsumerState<LoginDetailsUpdate> {
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController phonecontroller = TextEditingController();

  int length = 0;
  double sum = 0;
  File? profileFile;
  void pickProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  double calculateAverageRating(List<Review> reviews) {
    if (reviews.isEmpty) {
      return 0.0; // Default value for no ratings
    }
    length = reviews.length;
    double sum = reviews
        .map((review) => review.rating)
        .reduce((value, element) => value + element);
    return sum / reviews.length;
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editProfile(
          profileFile: profileFile,
          context: context,
          name: namecontroller.text.trim(),
          email: emailcontroller.text.trim(),
          phoneno: phonecontroller.text.trim(),
        );
  }

  @override
  void dispose() {
    namecontroller.dispose();
    emailcontroller.dispose();
    phonecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.read(userProvider);

    if (user!.reviews != null) {
      sum = calculateAverageRating(user.reviews!);
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: Constants.appBarGradient,
          ),
        ),
        title: Text(
          'Login Details',
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    pickProfileImage();
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: profileFile == null
                        ? NetworkImage(
                            user.profilePic,
                          )
                        : FileImage(
                            File(profileFile!.path),
                          ) as ImageProvider<Object>?,
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.camera,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Name'),
              ProfileEditField(controller: namecontroller, name: user.name),
              const SizedBox(
                height: 10,
              ),
              const Text('Email'),
              ProfileEditField(controller: emailcontroller, name: user.email),
              const SizedBox(
                height: 10,
              ),
              const Text('Phone No.'),
              ProfileEditField(controller: phonecontroller, name: user.phoneNo),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Your Reviews:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SmoothStarRating(
                    rating: sum,
                    size: 40,
                    allowHalfRating: true,
                    color: Colors.amber,
                    borderColor: Colors.amber,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Over All Rating',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              Text(
                "$sum Rating Base on $length Reviews",
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  if (namecontroller.text.isEmpty) {
                    namecontroller.text = user.name;
                  }
                  if (emailcontroller.text.isEmpty) {
                    emailcontroller.text = user.email;
                  }
                  if (phonecontroller.text.isEmpty) {
                    phonecontroller.text = user.phoneNo;
                  }
                  save();
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
                    'Update',
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
