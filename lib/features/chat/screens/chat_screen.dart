import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentify/core/constants/constants.dart';
import 'package:rentify/features/chat/screens/all_screen.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: Constants.appBarGradient,
            ),
          ),
          title: Text(
            'Chat Screens',
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Lessee'),
              Tab(text: 'Rented'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AllScreen(),
            Center(child: Text('Tab 2 Content')),
            Center(child: Text('Tab 3 Content')),
          ],
        ),
      ),
    );
  }
}
