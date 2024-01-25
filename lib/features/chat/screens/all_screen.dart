import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rentify/features/chat/screens/widgets/all_items.dart';

class AllScreen extends ConsumerWidget {
  const AllScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime dateTime = DateTime.now();

    // Format the DateTime object to day/month format
    String formattedDate = DateFormat('HH:mm').format(dateTime);
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: AllItems(formattedDate: formattedDate),
          );
        },
      ),
    );
  }
}
