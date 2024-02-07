import 'package:flutter/material.dart';

class SearchBarHome extends StatelessWidget {
  const SearchBarHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          enabled: false,
          decoration: InputDecoration(
            hintText: 'Search',
            prefixIcon: Icon(Icons.search),
            suffixIcon: Icon(Icons.clear),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
