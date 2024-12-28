// ignore_for_file: prefer_const_constructors

import 'package:edificators_hub_mobile/dynamic/providers/course_provider.dart';
import 'package:edificators_hub_mobile/dynamic/providers/enrollment_provider.dart';
import 'package:edificators_hub_mobile/static/pages/student/others/student_course_search_page.dart';
import 'package:edificators_hub_mobile/static/widgets/cards/custom_home_card.dart';
import 'package:edificators_hub_mobile/static/widgets/cards/enrolled_course_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../commons/colors.dart';
import '../../../../dynamic/dtos/responses/course/enrolled_courses_response.dart';
import '../../../../dynamic/dtos/responses/student_dashboard_response.dart';
import '../../../../dynamic/providers/dashboard_provider.dart';
import '../../../../commons/loader.dart';
import '../../../widgets/texts/custom_text.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // GET DASHBOARD
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    StudentDashboardResponse? dashboardResponse =
        dashboardProvider.getStudentDashboardState.response;
    // GET COURSES
    final enrollmentProvider = Provider.of<EnrollmentProvider>(context);
    List<EnrolledCoursesResponse>? enrolledCourses =
        enrollmentProvider.getEnrolledCoursesListState.response;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // GET COURSES
          final courseProvider =
              Provider.of<CourseProvider>(context, listen: false);
          courseProvider.listCourseByGrade();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentCourseSearchPage(),
            ),
          );
        },
        backgroundColor: MyColor.tealColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Enroll"),
      ),
      body: (dashboardProvider.getTeacherDashboardState.isLoading ||
              enrollmentProvider.getEnrolledCoursesListState.isLoading)
          ? const Loader()
          : enrolledCourses != null && enrolledCourses.isEmpty
              ? Center(
                  child: CustomText(
                    text: "Click + Enroll to see courses",
                    fontSize: 16,
                    color: MyColor.tealColor,
                  ),
                )
              : Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            color: MyColor.tealColor,
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 35),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: "Edificator Hub",
                                  fontSize: 18,
                                  color: MyColor.whiteColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                IconButton(
                                  icon: Icon(Icons.notifications,
                                      color: MyColor.tealColor),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.001),
                            CustomHomeCard(
                              count1: dashboardResponse?.assignmentCount
                                      .toString() ??
                                  "0",
                              count2: dashboardResponse?.quizCount.toString() ??
                                  "0",
                              name: dashboardResponse?.fullName ?? "--",
                              text1: "Assignment",
                              text2: "Quiz",
                            ),
                            SizedBox(height: height * 0.03),
                            CustomText(
                              text: "Enrolled Courses",
                              fontSize: 22,
                              color: MyColor.blueColor,
                              fontWeight: FontWeight.w700,
                            ),
                            SizedBox(
                              height: height * 0.012,
                            ),
                            Container(
                              padding: EdgeInsets.zero,
                              height:
                                  height * 0.5, // Set height for the GridView
                              child: GridView.builder(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.0), // Padding for GridView
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, // Number of columns
                                  crossAxisSpacing: 12, // Space between columns
                                  mainAxisSpacing: 10, // Space between rows
                                  childAspectRatio:
                                      0.75, // Adjust aspect ratio for card height/width
                                ),
                                itemCount: enrolledCourses?.length,
                                itemBuilder: (context, index) {
                                  return EnrolledCourseCard(
                                      enrolledCourse: enrolledCourses?[index]);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
