// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:edificators_hub_mobile/static/pages/teacher/teacher_dashboard/chat/teacher_chatting_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../commons/generic_list.dart';
import '../../../../../commons/image_utils.dart';
import '../../../../../commons/shared_pref.dart';
import '../../../../../dynamic/dtos/responses/user/list_student_response.dart';
import '../../../../../dynamic/providers/user_provider.dart';
import '../../../../widgets/texts/custom_text.dart';

class TeacherStudentSearchPage extends StatefulWidget {
  const TeacherStudentSearchPage({super.key});

  @override
  State<TeacherStudentSearchPage> createState() =>
      _TeacherStudentSearchPageState();
}

class _TeacherStudentSearchPageState extends State<TeacherStudentSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<ListStudentsResponse>? _filteredStudents;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    // GET STUDENTS
    final userProvider = Provider.of<UserProvider>(context);
    List<ListStudentsResponse>? students =
        userProvider.listStudentState.response;

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
              child: GenericList<ListStudentsResponse>(
                isLoading: userProvider.listStudentState.isLoading,
                items: _filteredStudents,
                emptyMessage: "No Students yet",
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
                                builder: (context) => TeacherChattingPage(
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

