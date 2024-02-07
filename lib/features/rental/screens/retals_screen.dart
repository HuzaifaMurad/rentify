import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentify/features/rental/screens/favortie_screen.dart';
import 'package:rentify/features/rental/screens/rentals_screen.dart';

import '../../../core/constants/constants.dart';

class RentalScreen extends ConsumerStatefulWidget {
  const RentalScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RentalScreenState();
}

class _RentalScreenState extends ConsumerState<RentalScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: Constants.appBarGradient,
            ),
          ),
          title: Text(
            'R E T A L S',
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Favorites'),
              Tab(text: 'Rentals'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            FavoriteScreen(),
            RentalsScreen(),
          ],
        ),
      ),
    );
  }
}
