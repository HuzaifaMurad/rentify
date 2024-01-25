import 'package:flutter/material.dart';

class CitiySearch extends StatelessWidget {
  const CitiySearch({super.key, required this.location});
  final String location;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 45,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Text(
        location,
        style: const TextStyle(
          // color: Colors.grey,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
