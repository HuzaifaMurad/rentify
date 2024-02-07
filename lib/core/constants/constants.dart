import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentify/models/category.dart';

class Constants {
  static const logo = 'assets/images/logo1.png';
  static const Color scaffoldbackgroundColor2 = Color(0xffE7E7E7);
  static const Color scaffoldbackgroundColor = Color(0xffD7D8D9);
  static List<Categorys> categories = [
    Categorys(title: 'House', icon: 'assets/images/house.png'),
    Categorys(title: 'Books', icon: 'assets/images/books.png'),
    Categorys(title: 'Vachile', icon: 'assets/images/car.png'),
    Categorys(title: 'Bike', icon: 'assets/images/bike.png'),
    Categorys(title: 'Clothes', icon: 'assets/images/shirt.png'),
    Categorys(title: 'Furniture', icon: 'assets/images/furniture.png'),
    Categorys(title: 'Game', icon: 'assets/images/console.png'),
  ];
  static List<Categorys> homeCategories = [
    Categorys(title: 'All', icon: 'assets/images/all.png'),
    Categorys(title: 'House', icon: 'assets/images/house.png'),
    Categorys(title: 'Books', icon: 'assets/images/books.png'),
    Categorys(title: 'Vachile', icon: 'assets/images/car.png'),
    Categorys(title: 'Bike', icon: 'assets/images/bike.png'),
    Categorys(title: 'Clothes', icon: 'assets/images/shirt.png'),
    Categorys(title: 'Furniture', icon: 'assets/images/furniture.png'),
    Categorys(title: 'Game', icon: 'assets/images/console.png'),
  ];

  static List<String> condition = ['New', 'Used', 'slightly Used'];

  static List<String> statuses = [
    'True',
    'False',
  ];
  static var titleRentify =
      GoogleFonts.raleway(fontSize: 17, fontWeight: FontWeight.w500);
  static var authText = GoogleFonts.deliusSwashCaps(
    fontSize: 30,
  );

  static const appBarGradient = LinearGradient(
    colors: [
      Color(0xff0ECEDA),
      Color(0xFFE9F5F5),
    ],
    stops: [0, 1],
  );
  static const buttonGredient = LinearGradient(
    colors: [
      Color(0xff01F9BD),
      Color(0xff057CE9),
    ],
    stops: [0.3, 1.0],
  );
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';
}
