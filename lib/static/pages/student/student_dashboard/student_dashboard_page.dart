// ignore_for_file: prefer_const_constructors, prefer_final_fields
import 'package:edificators_hub_mobile/dynamic/providers/enrollment_provider.dart';
import 'package:edificators_hub_mobile/static/pages/student/student_dashboard/student_home_Page.dart';
import 'package:edificators_hub_mobile/static/pages/student/student_dashboard/chat/student_chat_page.dart';
import 'package:edificators_hub_mobile/static/pages/teacher/teacher_dashboard/teacher_account_page.dart';
import 'package:flutter/material.dart';
import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:provider/provider.dart';

import '../../../../dynamic/providers/dashboard_provider.dart';
import '../../../../dynamic/providers/user_provider.dart';

// import 'chat/student_chat_page.dart';

class StudentDashboardPage extends StatefulWidget {
  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends State<StudentDashboardPage> {
  // INITIAL CALLS
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.getUserProfile();
      final dashboardProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      dashboardProvider.getStudentDashboard();
      final enrollementProvider =
          Provider.of<EnrollmentProvider>(context, listen: false);
      enrollementProvider.listEnrolledCourses();
    });
  }

  int _selectedIndex = 0;

  // List of screens for other tabs
  static List<Widget> _pages = <Widget>[
    StudentHomePage(),
    StudentChatPage(),
    TeacherAccountPage(),
  ];

  // Function to handle navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Switch between tabs
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: MyColor.whiteColor,
        selectedItemColor: MyColor.blueColor,
        unselectedItemColor: MyColor.tealColor,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
