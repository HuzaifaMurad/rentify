import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class LoginIcon extends ConsumerWidget {
  final String icon;
  final Function() ontap;

  const LoginIcon({super.key, required this.icon, required this.ontap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: ontap,
      child: Material(
        shape: const CircleBorder(eccentricity: 1),
        elevation: 5,
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
          child: Image(
            image: AssetImage(
              icon,
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
