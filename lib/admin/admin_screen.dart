import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminPanelDashboard extends ConsumerStatefulWidget {
  const AdminPanelDashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminPanelDashboardState();
}

class _AdminPanelDashboardState extends ConsumerState<AdminPanelDashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('123'),
      ),
    );
  }
}
