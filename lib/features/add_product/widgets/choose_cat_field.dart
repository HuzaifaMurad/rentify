import 'package:flutter/material.dart';

class ChooseCategoryField extends StatelessWidget {
  const ChooseCategoryField(
      {super.key, required this.selectedCategory, required this.title});

  final String selectedCategory;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      child: TextFormField(
        controller: TextEditingController(text: selectedCategory),
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: title,
          enabled: false,
          suffixIcon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.black,
          ),
          contentPadding: const EdgeInsets.all(8),
          border: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black, // Border color
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black54, // Border color when disabled
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelStyle: const TextStyle(
            color: Colors.black, // Text color
          ),
        ),
      ),
    );
  }
}
