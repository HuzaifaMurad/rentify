import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentify/features/auth/controller/auth_controller.dart';

import '../../../core/constants/constants.dart';
import '../widgets/profile_screen_listtile.dart';
import 'login_details_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var height = MediaQuery.of(context).size.height;
    var user = ref.read(userProvider);
    print("${user!.id} id profile");
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      user.profilePic ??
                          'https://media.timeout.com/images/105805277/750/422/image.jpg',
                    ),
                  ),
                ),
                Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const Text(
                  'Account Detail',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Container(
                height: height * 0.4,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xff1B5F6E),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => LoginDetailsUpdate(),
                          ),
                        );
                      },
                      child: const ProfileScreenListTile(
                        icon: Icons.person,
                        title: 'Login Details',
                        subtitle: 'Username , Password',
                      ),
                    ),
                    Container(
                      height: 3,
                      color: const Color(0xff2c6c7a),
                    ),
                    const ProfileScreenListTile(
                      icon: Icons.notifications,
                      title: 'Notifications',
                      subtitle: 'Rental History,Anonucments',
                    ),
                    Container(
                      height: 3,
                      color: const Color(0xff2c6c7a),
                    ),
                    const ProfileScreenListTile(
                      icon: Icons.notes,
                      title: 'Legal Informations',
                      subtitle: 'Terms and Condidion,Privacy Policy',
                    ),
                    Container(
                      height: 3,
                      color: const Color(0xff2c6c7a),
                    ),
                    const ProfileScreenListTile(
                      icon: Icons.help_outline_sharp,
                      title: 'Help',
                      subtitle: 'FAQS,Helpdesk',
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                ref.watch(authControllerProvider.notifier).signOut();
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: Constants.buttonGredient,
                  ),
                  child: Text(
                    'Logout',
                    style: GoogleFonts.raleway(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
