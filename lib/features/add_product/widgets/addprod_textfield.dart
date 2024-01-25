import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddProdTextField extends ConsumerWidget {
  const AddProdTextField({
    super.key,
    required this.title,
    this.maxlines = 1,
    this.color = Colors.black54,
    required this.controller,
  });
  final TextEditingController controller;
  final String title;
  final int? maxlines;
  final Color? color;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      child: TextField(
        controller: controller,
        maxLines: maxlines,
        // controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: color!,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: title,
        ),
      ),
    );
  }
}
