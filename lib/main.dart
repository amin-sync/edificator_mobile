import 'package:edificators_hub_mobile/commons/api_constants.dart';
import 'package:edificators_hub_mobile/dynamic/providers/course_provider.dart';
import 'package:edificators_hub_mobile/dynamic/providers/dashboard_provider.dart';
import 'package:edificators_hub_mobile/dynamic/providers/enrollment_provider.dart';
import 'package:edificators_hub_mobile/dynamic/providers/notes_provider.dart';
import 'package:edificators_hub_mobile/dynamic/providers/quiz_provider.dart';
import 'package:edificators_hub_mobile/dynamic/providers/user_provider.dart';
import 'package:edificators_hub_mobile/commons/shared_pref.dart';
import 'package:edificators_hub_mobile/static/pages/auth/login_page.dart';
import 'package:edificators_hub_mobile/static/pages/student/student_dashboard/student_dashboard_page.dart';
import 'package:edificators_hub_mobile/static/pages/teacher/teacher_dashboard/teacher_dashboard_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dynamic/providers/announcement_provider.dart';
import 'dynamic/providers/assignment_provider.dart';
import 'dynamic/providers/auth_provider.dart';
import 'dynamic/providers/payment_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPref().initializeVariables();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => AssignmentProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => EnrollmentProvider()),
        ChangeNotifierProvider(create: (_) => NotesProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Edificators Hub",
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
          ),
          home: FutureBuilder(
              future: Future.wait<dynamic>(
                [
                  SharedPref().readBool("isLogin"),
                  SharedPref().readInt("roleId"),
                ],
              ).then((results) => results.cast<dynamic>().toList()),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return LoginPage();
                } else {
                  List<dynamic> results = snapshot.data as List<dynamic>;
                  bool isLogin = results[0] as bool;
                  int roleId = results[1] as int;
                  if (isLogin && roleId == ApiConstant.teacherRoleId) {
                    return TeacherDashboardPage();
                  } else if (isLogin && roleId == ApiConstant.studentRoleId) {
                    return StudentDashboardPage();
                  }
                  return LoginPage();
                }
              })),
    );
  }
}
