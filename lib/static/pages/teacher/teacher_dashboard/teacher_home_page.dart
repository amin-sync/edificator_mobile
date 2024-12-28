import 'package:edificators_hub_mobile/dynamic/providers/assignment_provider.dart';
import 'package:edificators_hub_mobile/dynamic/providers/course_provider.dart';
import 'package:edificators_hub_mobile/dynamic/providers/dashboard_provider.dart';
import 'package:edificators_hub_mobile/dynamic/providers/notes_provider.dart';
import 'package:edificators_hub_mobile/dynamic/providers/quiz_provider.dart';
import 'package:edificators_hub_mobile/static/widgets/cards/custom_home_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../commons/generic_list.dart';
import '../../../../dynamic/dtos/responses/course/teacher_course_list_response.dart';
import '../../../../dynamic/dtos/responses/teacher_dashboard_response.dart';
import '../../../../dynamic/providers/announcement_provider.dart';
import '../../../../commons/colors.dart';
import '../../../widgets/dialogues/custom_course_dialogue.dart';
import '../../../widgets/bottomsheet/custom_bottom_sheet_tile.dart';
import '../../../widgets/cards/status_card.dart';
import '../../../../commons/loader.dart';
import '../../../widgets/texts/custom_text.dart';
import '../others/teacher_announcement_page.dart';
import '../others/teacher_assignment_page.dart';
import '../others/teacher_share_notes_page.dart';
import '../others/teacher_upload_quiz_page.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // GET DASHBOARD
    final dashboardProvider = Provider.of<DashboardProvider>(context);
    TeacherDashboardResponse? dashboardResponse =
        dashboardProvider.getTeacherDashboardState.response;
    // GET COURSES
    final courseProvider = Provider.of<CourseProvider>(context);
    List<TeacherCourseListResponse>? courses =
        courseProvider.getTeacherCourseListState.response;
    return (dashboardProvider.getTeacherDashboardState.isLoading ||
            courseProvider.getTeacherCourseListState.isLoading)
        ? const Loader()
        : Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => CustomCourseDialogue(
                    title: " Create Course",
                    isCreate: true,
                    course: null,
                  ),
                );
              },
              backgroundColor: MyColor.tealColor,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Course"),
            ),
            body: Stack(
              children: [
                // Background layers
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
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => TeacherNotification(),
                                //   ),
                                // );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.001),
                        CustomHomeCard(
                          count1:
                              dashboardResponse?.courseCount.toString() ?? "0",
                          count2: dashboardResponse?.enrolledStudentCount
                                  .toString() ??
                              "0",
                          name: dashboardResponse?.fullName ?? "--",
                          text1: "Courses",
                          text2: "Students",
                        ),
                        SizedBox(height: height * 0.03),
                        CustomText(
                          text: "Your Courses",
                          fontSize: 22,
                          color: MyColor.blueColor,
                          fontWeight: FontWeight.w700,
                        ),
                        Container(
                          padding: EdgeInsets.zero,
                          height: height * 0.55, // Adjust height as needed
                          child: GenericList<TeacherCourseListResponse>(
                            isLoading: courseProvider
                                .getTeacherCourseListState.isLoading,
                            items: courses,
                            emptyMessage: "Click + course to create course.",
                            itemBuilder: (context, course) {
                              return Card(
                                elevation: 5,
                                color: MyColor.whiteColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 4),
                                  child: ListTile(
                                    title: CustomText(
                                      text: course.subject,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: MyColor.tealColor,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: height * 0.008),
                                        CustomText(
                                          text: course.grade,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: MyColor.tealColor,
                                        ),
                                        SizedBox(height: height * 0.010),
                                        CustomStatusCard(
                                          text: "${course.fee} PKR",
                                          backgroundColor: Colors
                                              .green[100]!, // Background color
                                          textColor:
                                              MyColor.greenColor, // Text color
                                        ),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.edit,
                                          color: MyColor.blueColor),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              CustomCourseDialogue(
                                            title:
                                                " Update Course", // Your custom title
                                            isCreate: false,
                                            course: course,
                                          ),
                                        );
                                      },
                                    ),
                                    onTap: () {
                                      _showBottomSheet(course.id);
                                    },
                                  ),
                                ),
                              );
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

  void _showBottomSheet(int courseId) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: false, // Prevent scrolling
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: width * 0.1,
              height: height * 0.006,
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: MyColor.tealColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // The bottom sheet content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomBottomSheetTile(
                    icon: Icons.announcement_sharp,
                    text: "Announcement",
                    textColor: MyColor.blueColor,
                    onTap: () {
                      // GET ANNOUNCEMENTS
                      final announcementProvider =
                          Provider.of<AnnouncementProvider>(context,
                              listen: false);
                      announcementProvider.listAnnouncement(courseId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeacherAnnouncementPage(
                                  courseId: courseId,
                                )),
                      );
                    },
                  ),
                  CustomBottomSheetTile(
                    icon: Icons.create,
                    text: "Assignment",
                    textColor: MyColor.blueColor,
                    onTap: () {
                      // GET ASSIGNMENTS
                      final assignmentProvider =
                          Provider.of<AssignmentProvider>(context,
                              listen: false);
                      assignmentProvider.listAssignmentByTeacher(courseId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeacherAssignmentPage(
                                  courseId: courseId,
                                )),
                      );
                    },
                  ),
                  CustomBottomSheetTile(
                    icon: Icons.upload,
                    text: "Quiz",
                    textColor: MyColor.blueColor,
                    onTap: () {
                      // GET QUIZ
                      final quizProvider =
                          Provider.of<QuizProvider>(context, listen: false);
                      quizProvider.listQuizByTeacher(courseId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeacherUploadQuizPage(
                                  courseId: courseId,
                                )),
                      );
                    },
                  ),
                  CustomBottomSheetTile(
                    icon: Icons.share,
                    text: "Notes",
                    textColor: MyColor.blueColor,
                    onTap: () {
                      // GET NOTES
                      final noteProvider =
                          Provider.of<NotesProvider>(context, listen: false);
                      noteProvider.listNotes(courseId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeacherShareNotesPage(
                                  courseId: courseId,
                                )),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
