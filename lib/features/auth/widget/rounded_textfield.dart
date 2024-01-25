// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class RoundedTextField extends StatefulWidget {
  final String name;
  final TextEditingController controller;
  bool obsecure;
  RoundedTextField(
      {super.key,
      required this.controller,
      required this.name,
      this.obsecure = false});

  @override
  State<RoundedTextField> createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  void toggleObscureText() {
    setState(() {
      widget.obsecure = !widget.obsecure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff5FF2FB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          textAlign: TextAlign.start,
          obscureText: widget.obsecure,
          controller: widget.controller,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            suffixIcon: widget.name.contains('password') ||
                    widget.name.contains('Password')
                ? IconButton(
                    onPressed: toggleObscureText,
                    icon: widget.obsecure
                        ? const Icon(Icons.remove_red_eye_outlined)
                        : const Icon(Icons.remove_red_eye),
                  )
                : null,
            hintText: widget.name,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ),
    );
  }
}
