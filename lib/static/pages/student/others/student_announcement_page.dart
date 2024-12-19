import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../commons/colors.dart';
import '../../../../commons/generic_list.dart';
import '../../../../dynamic/dtos/responses/announcement_response.dart';
import '../../../../dynamic/providers/announcement_provider.dart';
import '../../../widgets/texts/custom_text.dart';

class StudentAnnouncementPage extends StatefulWidget {
  final int courseId;
  const StudentAnnouncementPage({super.key, required this.courseId});

  @override
  State<StudentAnnouncementPage> createState() =>
      _StudentAnnouncementPageState();
}

class _StudentAnnouncementPageState extends State<StudentAnnouncementPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startPeriodicUpdate();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _startPeriodicUpdate() {
    _timer = Timer.periodic(Duration(seconds: 7), (timer) {
      _fetchAnnouncements();
    });
  }

  void _fetchAnnouncements() {
    final announcementProvider =
        Provider.of<AnnouncementProvider>(context, listen: false);
    announcementProvider.listAnnouncement(widget.courseId);
    setState(() {
      announcementProvider.getAnnouncementListState.response
          ?.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
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
        padding: const EdgeInsets.all(16),
        child: GenericList<AnnouncementResponse>(
          isLoading: announcementProvider.getAnnouncementListState.isLoading,
          items: announcements,
          emptyMessage: "No Announcements yet",
          itemBuilder: (context, announcement) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: MyColor.tealColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
