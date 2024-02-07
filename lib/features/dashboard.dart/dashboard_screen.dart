import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rentify/features/add_product/screen/add_product.dart';
import 'package:rentify/features/chat/screens/chat_screen.dart';
import 'package:rentify/features/dashboard.dart/widget/navbar_customIcon.dart';
import 'package:rentify/features/home/screen/home_screen.dart';
import 'package:rentify/features/rental/screens/retals_screen.dart';
import 'package:rentify/features/user_profile/screen/profile_screen.dart';

import '../../core/utility.dart';

List pages = [
  const HomeScreen(),
  const RentalScreen(),
  const AddProductScreen(),
  const ChatScreen(),
  const ProfileScreen()
];

ThemeData customBottomNavigationBarTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
);

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  void initState() {
    super.initState();
    getCitiesData();
  }

  getCitiesData() async {
    cities = await fetchCitiesFromJsonAsset('assets/cities/cities.json');
    log(cities.first.name);
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xff0ECEDA),
        unselectedItemColor: Colors.black,
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.star,
                size: 30,
              ),
              label: 'Retals'),
          BottomNavigationBarItem(icon: CustomIcon(), label: 'add'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.message,
                size: 30,
              ),
              label: 'message'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: 'profile'),
        ],
      ),
      body: pages[index],
    );
  }
}
