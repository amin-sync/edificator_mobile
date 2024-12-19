import 'package:flutter/material.dart';

import '../../../commons/colors.dart';
import '../buttons/custom_small_button.dart';
import '../texts/custom_text.dart';

class AnnouncementDialog extends StatelessWidget {
  final TextEditingController createAnnouncementController;

  const AnnouncementDialog({
    Key? key,
    required this.createAnnouncementController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Center(
        child: CustomText(
          text: "Announcement",
          color: MyColor.blueColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: createAnnouncementController,
              cursorColor: MyColor.blueColor,
              maxLines: null,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: MyColor.blueColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: MyColor.blueColor),
                ),
                border: OutlineInputBorder(),
                hintText: 'Type here...',
                labelStyle: TextStyle(color: MyColor.blueColor),
                alignLabelWithHint: true,
              ),
              style: TextStyle(color: MyColor.blackColor),
            ),
            SizedBox(height: height * 0.022),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomSmallButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: "Cancel",
                  textColor: MyColor.tealColor,
                  backgroundColor: MyColor.whiteColor,
                ),
                CustomSmallButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: "Post",
                  backgroundColor: MyColor.tealColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
