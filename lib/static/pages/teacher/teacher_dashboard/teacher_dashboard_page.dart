// ignore_for_file: prefer_const_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables

import 'package:edificators_hub_mobile/dynamic/providers/dashboard_provider.dart';
import 'package:edificators_hub_mobile/dynamic/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:provider/provider.dart';
import '../../../../dynamic/providers/course_provider.dart';
import 'teacher_account_page.dart';
import 'teacher_home_page.dart';
import 'chat/teacher_chat_page.dart';

class TeacherDashboardPage extends StatefulWidget {
  @override
  State<TeacherDashboardPage> createState() => _TeacherDashboardPageState();
}

class _TeacherDashboardPageState extends State<TeacherDashboardPage> {
  // INITIAL CALLS
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.getUserProfile();
      final dashboardProvider =
          Provider.of<DashboardProvider>(context, listen: false);
      dashboardProvider.getTeacherDashboard();
      final courseProvider =
          Provider.of<CourseProvider>(context, listen: false);
      courseProvider.listTeacherCourse();
    });
  }

  int _selectedIndex = 0;

  // Function to handle navigation
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = <Widget>[
      TeacherHomePage(),
      TeacherChatPage(),
      TeacherAccountPage(),
    ];
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: MyColor.whiteColor,
        selectedItemColor: MyColor.blueColor,
        unselectedItemColor: MyColor.tealColor,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
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
