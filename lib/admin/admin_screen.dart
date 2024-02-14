import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rentify/admin/widget/dashboard_ui.dart';
import 'package:rentify/admin/widget/user_ui.dart';
import 'package:rentify/core/constants/constants.dart';

class AdminPanelDashboard extends ConsumerStatefulWidget {
  const AdminPanelDashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AdminPanelDashboardState();
}

class _AdminPanelDashboardState extends ConsumerState<AdminPanelDashboard> {
  String _selectedOption = "Dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidePanel(
            selectedOption: _selectedOption,
            onOptionSelected: (option) {
              setState(() {
                _selectedOption = option;
              });
            },
          ),
          Expanded(
            child: Container(
              color: Constants.adminPanelColor,
              padding: EdgeInsets.all(20.sp),
              child: Center(
                child: _buildSelectedOptionUI(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedOptionUI() {
    switch (_selectedOption) {
      case "Dashboard":
        return const DashBoardUI();
      case "Users":
        return const UserUI();
      case "Settings":
        return Text('Settings UI');
      default:
        return Text('No UI selected');
    }
  }
}

class SidePanel extends StatelessWidget {
  final String selectedOption;
  final Function(String) onOptionSelected;

  const SidePanel(
      {super.key,
      required this.selectedOption,
      required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20.h),
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                height: 50.h,
                width: 60.w,
                child: Image.asset(
                  Constants.logo,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                'RENTIFY',
                style: Constants.titleRentify,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildOptionButton("Dashboard", Icons.dashboard),
          _buildOptionButton("Users", Icons.people),
          _buildOptionButton("Settings", Icons.settings),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String option, IconData icon) {
    return TextButton(
      onPressed: () {
        onOptionSelected(option);
      },
      style: ButtonStyle(
        overlayColor:
            MaterialStateColor.resolveWith((states) => Colors.transparent),
        foregroundColor: MaterialStateColor.resolveWith(
            (states) => selectedOption == option ? Colors.white : Colors.grey),
        backgroundColor: MaterialStateColor.resolveWith((states) =>
            selectedOption == option ? Colors.black : Colors.transparent),
      ),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 10),
          Text(option),
        ],
      ),
    );
  }
}
