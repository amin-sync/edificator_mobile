import 'package:cached_network_image/cached_network_image.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/responses/user/list_teacher_response.dart';
import 'package:edificators_hub_mobile/static/pages/student/student_dashboard/chat/student_chatting_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../commons/colors.dart';
import '../../../../../commons/generic_list.dart';
import '../../../../../commons/image_utils.dart';
import '../../../../../commons/shared_pref.dart';
import '../../../../../dynamic/providers/user_provider.dart';
import '../../../../widgets/texts/custom_text.dart';

class StudentTeacherSearchPage extends StatefulWidget {
  const StudentTeacherSearchPage({super.key});

  @override
  State<StudentTeacherSearchPage> createState() => _StudentTeacherSearchPageState();
}

class _StudentTeacherSearchPageState extends State<StudentTeacherSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<ListTeacherResponse>? _filteredStudents;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // GET STUDENTS
    final userProvider = Provider.of<UserProvider>(context);
    List<ListTeacherResponse>? students =
        userProvider.listTeacherState.response;

    // Initialize the filtered list if it is null
    _filteredStudents ??= students;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: height * 0.05), // Spacing from top
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: MyColor.blueColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // Light grey color
                      borderRadius: BorderRadius.circular(25), // Round shape
                    ),
                    child: TextField(
                      controller: _searchController,
                      cursorColor: MyColor.blueColor,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(15),
                      ),
                      onChanged: (query) {
                        setState(() {
                          if (query.isEmpty) {
                            _filteredStudents = students;
                          } else {
                            _filteredStudents = students
                                ?.where((student) => student.fullName
                                .toLowerCase()
                                .contains(query.toLowerCase()))
                                .toList();
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: GenericList<ListTeacherResponse>(
                isLoading: userProvider.listStudentState.isLoading,
                items: _filteredStudents,
                emptyMessage: "No Teachers yet",
                itemBuilder: (context, student) {
                  return Column(
                    children: [
                      ListTile(
                          onTap: () async {
                            int currentUserId =
                            await SharedPref().readInt("userId");
                            Navigator.of(context).pop();

                            // CHATTING PAGE
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentChattingPage(
                                  receiverName: student.fullName,
                                  receiverProfileUrl:
                                  student.profileUrl ?? "",
                                  receiverUserId: student.id.toString(),
                                  currentUserId: currentUserId.toString(),
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
                              backgroundImage: student.profileUrl == null
                                  ? AssetImage(ImageUtils.profilePicture)
                                  : CachedNetworkImageProvider(
                                "${student.profileUrl}?t=${DateTime.now().millisecondsSinceEpoch}",
                              ) as ImageProvider<Object>,
                            ),
                          ),
                          title: CustomText(
                            text: student.fullName,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: MyColor.tealColor,
                          )),
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
