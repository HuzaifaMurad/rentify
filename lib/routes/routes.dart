import 'package:flutter/material.dart';
import 'package:rentify/features/add_product/screen/Edit_product.dart';
import 'package:rentify/features/auth/screen/fingerprint_screen.dart';
import 'package:rentify/features/auth/screen/login_screen.dart';
import 'package:rentify/features/auth/screen/signup_screen.dart';
import 'package:rentify/features/home/screen/product_detail_screen.dart';
import 'package:rentify/features/home/screen/user_details_scrreen.dart';
import 'package:rentify/features/rental/screens/widget/rentals_detail.dart';

import '../models/product.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const LoginScreen(),
      );

    case SignupScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const SignupScreen(),
      );

    case FingerprintScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const FingerprintScreen(),
      );
    case ProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => ProductDetailScreen(
          product: product,
        ),
      );
    case UserDetasilsScreen.routeName:
      var userid = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => UserDetasilsScreen(id: userid),
      );
    case RentalsDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => RentalsDetailScreen(
          product: product,
        ),
      );
    case EditProductScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => EditProductScreen(
          product: product,
        ),
      );

    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const Scaffold(
          body: Center(
            child: Text(
              'THE SCREEN DOES NOT EXIST YET',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
        ),
      );
  }
}
