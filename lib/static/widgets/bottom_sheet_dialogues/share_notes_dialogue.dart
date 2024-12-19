import 'package:flutter/material.dart';
import '../../../commons/colors.dart';
import '../buttons/custom_small_button.dart';
import '../fields/custom_field.dart';
import '../texts/custom_text.dart';

class ShareNotesDialog extends StatelessWidget {
  final TextEditingController shareNotesController;
  final Function pickFile;
  final String? fileName;

  const ShareNotesDialog({
    Key? key,
    required this.shareNotesController,
    required this.pickFile,
    this.fileName,
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
          text: "Share Notes",
          color: MyColor.blueColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomField(
              label: 'Title',
              controller: shareNotesController,
            ),
            SizedBox(height: height * 0.01),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: height * 0.02),
                  CustomSmallButton(
                    text: "Choose File",
                    onPressed: () => pickFile(),
                    backgroundColor: MyColor.blueColor,
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    fileName ?? 'No file chosen',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.01),
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
                  text: "Share",
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
