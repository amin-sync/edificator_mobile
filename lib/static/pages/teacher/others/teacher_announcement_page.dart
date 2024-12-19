// ignore_for_file: prefer_const_constructors

import 'package:edificators_hub_mobile/dynamic/providers/announcement_provider.dart';
import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:edificators_hub_mobile/commons/loader.dart';
import 'package:edificators_hub_mobile/static/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../dynamic/dtos/requests/announcement/create_announcement_request.dart';
import '../../../../dynamic/dtos/responses/announcement_response.dart';
import '../../../../commons/toast.dart';

class TeacherAnnouncementPage extends StatefulWidget {
  final int courseId;
  const TeacherAnnouncementPage({super.key, required this.courseId});

  @override
  State<TeacherAnnouncementPage> createState() =>
      _TeacherAnnouncementPageState();
}

class _TeacherAnnouncementPageState extends State<TeacherAnnouncementPage> {
  final TextEditingController messageController = TextEditingController();

  Future<void> onSendPressed(
      BuildContext context, AnnouncementProvider announcementProvider) async {
    CreateAnnouncementRequest request = CreateAnnouncementRequest(
      message: messageController.text,
      courseId: widget.courseId,
    );

    await announcementProvider.sendAnnouncement(request);

    if (!announcementProvider.getCreateAnnouncementState.success) {
      CustomToast.showDangerToast("Failed to send.");
    }
    announcementProvider.listAnnouncement(widget.courseId);
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    //GET ANNOUNCEMENTS
    final announcementProvider = Provider.of<AnnouncementProvider>(context);
    List<AnnouncementResponse>? announcements =
        announcementProvider.getAnnouncementListState.response;
    announcements?.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: CustomText(
          text: "Announcement",
          fontSize: 22,
          color: MyColor.tealColor,
          fontWeight: FontWeight.w700,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: MyColor.blueColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: announcementProvider.getAnnouncementListState.isLoading
                    ? Loader()
                    : announcements!.isEmpty
                        ? Center(
                            child: CustomText(
                              text: "No Announcements yet.",
                              fontSize: 16,
                              color: MyColor.tealColor,
                            ),
                          )
                        : ListView.builder(
                            reverse: true,
                            itemCount: announcements.length,
                            itemBuilder: (context, index) {
                              final announcement = announcements[index];
                              return Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 15),
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: MyColor.tealColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: announcement.message,
                                        fontSize: 16,
                                        color: MyColor.whiteColor,
                                      ),
                                      SizedBox(height: height * 0.010),
                                      Text(
                                        DateFormat('MMM d, yyyy hh:mm a')
                                            .format(announcement.createdDate),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: MyColor.greyColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        cursorColor: MyColor.tealColor,
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "message...",
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    Container(
                      decoration: BoxDecoration(
                        color: MyColor.tealColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.send, color: Colors.white),
                        onPressed: () {
                          onSendPressed(context, announcementProvider);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
