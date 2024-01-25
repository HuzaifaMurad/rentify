import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentify/core/constants/constants.dart';
import 'package:rentify/features/user_profile/widgets/profile_editfield.dart';

class LoginDetailsUpdate extends ConsumerStatefulWidget {
  const LoginDetailsUpdate({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoginDetailsUpdateState();
}

class _LoginDetailsUpdateState extends ConsumerState<LoginDetailsUpdate> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
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
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(
                    'https://media.timeout.com/images/105805277/750/422/image.jpg',
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Name'),
              ProfileEditField(controller: controller, name: 'Huzaifa'),
              const SizedBox(
                height: 10,
              ),
              const Text('Email'),
              ProfileEditField(
                  controller: controller, name: 'Huzaifa@gmail.com'),
              const SizedBox(
                height: 10,
              ),
              const Text('Phone No.'),
              ProfileEditField(controller: controller, name: 'Phone No.'),
              const SizedBox(
                height: 20,
              ),
              Container(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
