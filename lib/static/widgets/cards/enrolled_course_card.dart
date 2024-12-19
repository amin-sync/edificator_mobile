// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edificators_hub_mobile/static/pages/student/others/student_course_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../commons/shared_pref.dart';
import '../../../dynamic/dtos/requests/assignment/student_assignment_list_request.dart';
import '../../../dynamic/dtos/requests/quiz/student_quiz_list_request.dart';
import '../../../dynamic/dtos/responses/course/enrolled_courses_response.dart';
import '../../../dynamic/providers/announcement_provider.dart';
import '../../../dynamic/providers/assignment_provider.dart';
import '../../../dynamic/providers/course_provider.dart';
import '../../../dynamic/providers/notes_provider.dart';
import '../../../dynamic/providers/quiz_provider.dart';
import '../../pages/student/others/student_announcement_page.dart';
import '../../pages/student/others/student_assignment_page.dart';
import '../../pages/student/others/student_notes_page.dart';
import '../../pages/student/others/student_quiz_page.dart';
import '../../../commons/colors.dart';
import '../../../commons/image_utils.dart';
import '../bottomsheet/custom_bottom_sheet_tile.dart';
import '../texts/custom_text.dart';

class EnrolledCourseCard extends StatefulWidget {
  final EnrolledCoursesResponse? enrolledCourse;

  const EnrolledCourseCard({
    Key? key,
    required this.enrolledCourse,
  }) : super(key: key);

  @override
  State<EnrolledCourseCard> createState() => _EnrolledCourseCardState();
}

class _EnrolledCourseCardState extends State<EnrolledCourseCard> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(
            vertical: 5, horizontal: 0), // Margin between cards
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width * 0.13,
              height: width * 0.13,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: MyColor.blueColor,
                  width: 1.5,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                // ignore: unnecessary_null_comparison
                backgroundImage: widget.enrolledCourse?.profileUrl == null
                    ? AssetImage(ImageUtils.profilePicture)
                    : CachedNetworkImageProvider(
                        "${widget.enrolledCourse?.profileUrl}?t=${DateTime.now().millisecondsSinceEpoch}",
                      ) as ImageProvider<Object>,
              ),
            ),
            SizedBox(height: 10),
            CustomText(
              text: widget.enrolledCourse?.subject ?? "",
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: MyColor.tealColor,
            ),
            SizedBox(height: 5),
            CustomText(
              text: widget.enrolledCourse?.name ?? "",
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: MyColor.greyColor, // Replace with your color constant
            ),
          ],
        ),
      ),
      onTap: _showBottomSheet,
    );
  }

  void _showBottomSheet() {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true, // Prevent scrolling
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: width * 0.1,
              height: height * 0.006,
              margin: EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                color: MyColor.tealColor,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            // The bottom sheet content
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CustomBottomSheetTile(
                    icon: Icons.remove_red_eye,
                    text: "View Course",
                    textColor: MyColor.blueColor,
                    onTap: () {
                      // GET DETAIL
                      final courseProvider =
                          Provider.of<CourseProvider>(context, listen: false);
                      courseProvider
                          .courseDetail(widget.enrolledCourse?.courseId ?? 0);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentCourseDetailPage(
                                  courseId:
                                      widget.enrolledCourse?.courseId ?? 0,
                                  isEnabled: true,
                                )),
                      );
                    },
                  ),
                  CustomBottomSheetTile(
                    icon: Icons.announcement,
                    text: "Announcement",
                    textColor: MyColor.blueColor,
                    onTap: () {
                      // GET ANNOUNCEMENTS
                      final announcementProvider =
                          Provider.of<AnnouncementProvider>(context,
                              listen: false);
                      announcementProvider.listAnnouncement(
                          widget.enrolledCourse?.courseId ?? 0);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentAnnouncementPage(
                                  courseId:
                                      widget.enrolledCourse?.courseId ?? 0,
                                )),
                      );
                    },
                  ),
                  CustomBottomSheetTile(
                    icon: Icons.assignment,
                    text: "Assignment",
                    textColor: MyColor.blueColor,
                    onTap: () async {
                      // GET ASSIGNMENTS
                      int studentId = await SharedPref().readInt("associateId");
                      StudentAssignmentListRequest request =
                          StudentAssignmentListRequest(
                              studentId: studentId,
                              courseId: widget.enrolledCourse?.courseId ?? 0);
                      final assignmentProvider =
                          Provider.of<AssignmentProvider>(context,
                              listen: false);
                      assignmentProvider.listAssignmentByStudent(request);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentAssignmentPage(
                                  courseId:
                                      widget.enrolledCourse?.courseId ?? 0,
                                )),
                      );
                    },
                  ),
                  CustomBottomSheetTile(
                    icon: Icons.quiz,
                    text: "Quiz",
                    textColor: MyColor.blueColor,
                    onTap: () async {
                      // GET QUIZ
                      int studentId = await SharedPref().readInt("associateId");
                      StudentQuizListRequest request = StudentQuizListRequest(
                          studentId: studentId,
                          courseId: widget.enrolledCourse?.courseId ?? 0);
                      final quizProvider =
                          Provider.of<QuizProvider>(context, listen: false);
                      quizProvider.listQuizByStudent(request);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentQuizPage(
                                courseId:
                                    widget.enrolledCourse?.courseId ?? 0)),
                      );
                    },
                  ),
                  CustomBottomSheetTile(
                    icon: Icons.notes,
                    text: "Notes",
                    textColor: MyColor.blueColor,
                    onTap: () {
                      // GET NOTES
                      final noteProvider =
                          Provider.of<NotesProvider>(context, listen: false);
                      noteProvider.listNotes(
                        widget.enrolledCourse?.courseId ?? 0,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => StudentNotesPage(
                                  courseId:
                                      widget.enrolledCourse?.courseId ?? 0,
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
