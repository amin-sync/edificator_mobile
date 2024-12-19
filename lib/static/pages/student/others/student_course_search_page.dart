import 'package:cached_network_image/cached_network_image.dart';
import 'package:edificators_hub_mobile/static/pages/student/others/student_course_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:provider/provider.dart';
import '../../../../commons/generic_list.dart';
import '../../../../commons/image_utils.dart';
import '../../../../dynamic/dtos/responses/course/course_list_by_grade_response.dart';
import '../../../../dynamic/providers/course_provider.dart';
import '../../../widgets/texts/custom_text.dart';

class StudentCourseSearchPage extends StatefulWidget {
  const StudentCourseSearchPage({super.key});

  @override
  State<StudentCourseSearchPage> createState() =>
      _StudentCourseSearchPageState();
}

class _StudentCourseSearchPageState extends State<StudentCourseSearchPage> {
  // TextEditingController _searchController = TextEditingController();
  // List<Map<String, String>> filteredCourses = [];

  // @override
  // void initState() {
  //   super.initState();
  //   // Initialize filteredCourses with all courses initially
  //   filteredCourses = AppConstants.searchCourses;
  //   _searchController.addListener(_filterCourses);
  // }

  // void _filterCourses() {
  //   final query = _searchController.text.toLowerCase();
  //   setState(() {
  //     filteredCourses = AppConstants.searchCourses.where((course) {
  //       final title = course['title']?.toLowerCase() ?? '';
  //       final teacher = course['teacher']?.toLowerCase() ?? '';
  //       return title.contains(query) || teacher.contains(query);
  //     }).toList();
  //   });
  // }

  // @override
  // void dispose() {
  //   _searchController.removeListener(_filterCourses);
  //   _searchController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // GET COURSES
    final courseProvider = Provider.of<CourseProvider>(context);
    List<CourseListByGradeResponse>? courses =
        courseProvider.getCourseListByGradeState.response;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomText(
          text: "Courses",
          fontSize: 22,
          color: MyColor.tealColor,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: MyColor.blueColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.grey[200],
            //     borderRadius: BorderRadius.circular(25),
            //   ),
            //   child: TextField(
            //     cursorColor: MyColor.blueColor,
            //     controller: _searchController,
            //     decoration: InputDecoration(
            //       hintText: 'Search courses...',
            //       border: InputBorder.none,
            //       contentPadding: const EdgeInsets.symmetric(
            //         horizontal: 20,
            //         vertical: 15,
            //       ),
            //       suffixIcon: IconButton(
            //         icon: Icon(Icons.close, color: MyColor.greyColor),
            //         onPressed: () {
            //           _searchController.clear();
            //           _filterCourses();
            //         },
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: height * 0.01),
            Expanded(
              child: GenericList<CourseListByGradeResponse>(
                isLoading: courseProvider.getCourseListByGradeState.isLoading,
                items: courses,
                emptyMessage: "No Courses yet",
                itemBuilder: (context, course) {
                  return Column(
                    children: [
                      ListTile(
                        onTap: () {
                          // GET DETAIL
                          final courseProvider = Provider.of<CourseProvider>(
                              context,
                              listen: false);
                          courseProvider.courseDetail(course.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentCourseDetailPage(
                                courseId: course.id,
                                isEnabled: false,
                              ),
                            ),
                          );
                        },
                        leading: Container(
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
                            backgroundImage: course.profileUrl == null
                                ? AssetImage(ImageUtils.profilePicture)
                                : CachedNetworkImageProvider(
                                    "${course.profileUrl}?t=${DateTime.now().millisecondsSinceEpoch}",
                                  ) as ImageProvider<Object>,
                          ),
                        ),
                        title: CustomText(
                          text: course.subject,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColor.tealColor,
                        ),
                        subtitle: CustomText(
                          text: course.teacherName,
                          fontSize: 12,
                          color: MyColor.greyColor,
                        ),
                      ),
                      const Divider(
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
