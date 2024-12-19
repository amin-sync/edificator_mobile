// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/responses/user/list_teacher_response.dart';
import 'package:edificators_hub_mobile/static/pages/student/student_dashboard/chat/student_chatting_page.dart';
import 'package:edificators_hub_mobile/static/pages/student/student_dashboard/chat/student_teacher_search_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../commons/colors.dart';
import '../../../../../commons/image_utils.dart';
import '../../../../../commons/loader.dart';
import '../../../../../commons/shared_pref.dart';
import '../../../../../commons/utility.dart';
import '../../../../../dynamic/providers/user_provider.dart';
import '../../../../widgets/texts/custom_text.dart';

class StudentChatPage extends StatefulWidget {
  const StudentChatPage({super.key});

  @override
  State<StudentChatPage> createState() => _StudentChatPageState();
}

class _StudentChatPageState extends State<StudentChatPage> {
  // INITIAL CALL
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.getListTeacherState.response == null) {
        userProvider.listTeachersByStudentId();
      }
    });
  }

  String? checkName(List<ListTeacherResponse> students, List chats) {
    for (var student in students) {
      for (var chat in chats) {
        if (student.fullName == chat['name']) {
          return student.profileUrl;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: CustomText(
            text: "Chats",
            fontSize: 22,
            color: MyColor.tealColor,
            fontWeight: FontWeight.w700,
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search, color: MyColor.blueColor),
              onPressed: () {
                userProvider.listTeachersByStudentId();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentTeacherSearchPage(),
                  ),
                );
              },
            ),
            SizedBox(width: width * 0.03),
          ]),
      body: userProvider.getListTeacherState.isLoading
          ? Loader()
          : FutureBuilder(
              future: SharedPref().readInt("userId"),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return chatLoader();
                } else {
                  int userId = snapshot.data as int;
                  return StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("chats")
                          .doc(userId.toString())
                          .collection(userId.toString())
                          .orderBy("timeStamp", descending: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Loader());
                        } else {
                          dynamic data = snapshot.data?.docs;
                          List<dynamic> chats = [];
                          for (var i in data) {
                            if (i != "INITIALS") {
                              chats.add(i);
                            }
                          }
                          return chats.length > 0
                              ? Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: SafeArea(
                                    child: Column(
                                      children: [
                                        SizedBox(height: height * 0.03),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: chats.length,
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  ListTile(
                                                    leading: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      backgroundImage: checkName(
                                                                  userProvider
                                                                      .getListTeacherState
                                                                      .response,
                                                                  chats) ==
                                                              null
                                                          ? AssetImage(ImageUtils
                                                              .profilePicture)
                                                          : CachedNetworkImageProvider(
                                                              "${checkName(userProvider.getListTeacherState.response, chats)}?t=${DateTime.now().millisecondsSinceEpoch}",
                                                            ) as ImageProvider<
                                                              Object>,
                                                    ),
                                                    title: CustomText(
                                                      text: chats[index]
                                                          ["name"],
                                                      color: MyColor.blueColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    subtitle: Text(
                                                      chats[index]["message"],
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 14,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                    trailing: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          chats[index][
                                                                      "timeStamp"] ==
                                                                  null
                                                              ? ""
                                                              : Utility
                                                                  .readTimestamp(
                                                                  chats[index][
                                                                      "timeStamp"],
                                                                ),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 12),
                                                        )
                                                      ],
                                                    ),
                                                    onTap: () async {
                                                      int currentUserId =
                                                          await SharedPref()
                                                              .readInt(
                                                                  "userId");
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              StudentChattingPage(
                                                            receiverName:
                                                                chats[index]
                                                                    ["name"],
                                                            receiverProfileUrl:
                                                                chats[index][
                                                                    "profileUrl"],
                                                            receiverUserId:
                                                                chats[index]
                                                                    ["userId"],
                                                            currentUserId:
                                                                currentUserId
                                                                    .toString(),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  Divider(
                                                      thickness: 1,
                                                      indent: 70,
                                                      endIndent: 10),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : chatLoader();
                        }
                      });
                }
              }),
    );
  }

  Widget chatLoader() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(14.0),
      child:
          CustomText(text: "No Chats.", fontSize: 16, color: MyColor.tealColor),
    ));
  }
}