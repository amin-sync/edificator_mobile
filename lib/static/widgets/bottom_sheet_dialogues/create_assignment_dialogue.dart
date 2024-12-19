import 'package:flutter/material.dart';

import '../../../commons/colors.dart';
import '../buttons/custom_small_button.dart';
import '../fields/custom_field.dart';
import '../texts/custom_text.dart';

class CreateAssignmentDialog extends StatefulWidget {
  final TextEditingController createAssignmentController;
  final Function pickFile;
  final String? fileName;

  const CreateAssignmentDialog({
    Key? key,
    required this.createAssignmentController,
    required this.pickFile,
    this.fileName,
  }) : super(key: key);

  @override
  _CreateAssignmentDialogState createState() => _CreateAssignmentDialogState();
}

class _CreateAssignmentDialogState extends State<CreateAssignmentDialog> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Center(
        child: CustomText(
          text: "Create Assignment",
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
              controller: widget.createAssignmentController,
            ),
            SizedBox(height: height * 0.01),
            // GestureDetector(
            //   onTap: () {
            //     DatePicker.showDatePicker(
            //       context,
            //       showTitleActions: true,
            //       onConfirm: (date) {
            //         setState(() {
            //           selectedDate = date;
            //         });
            //       },
            //       currentTime: selectedDate,
            //       locale: LocaleType.en,
            //     );
            //   },
            //   child: Container(
            //     padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            //     decoration: BoxDecoration(
            //       border: Border.all(color: MyColor.blueColor),
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           "${selectedDate.toLocal()}".split(' ')[0],
            //           style: TextStyle(color: MyColor.blueColor, fontSize: 16),
            //         ),
            //         Icon(Icons.calendar_today, color: MyColor.blueColor),
            //       ],
            //     ),
            //   ),
            // ),
            SizedBox(height: height * 0.02),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSmallButton(
                    text: "Choose File",
                    onPressed: () => widget.pickFile(),
                    backgroundColor: MyColor.blueColor,
                  ),
                  SizedBox(height: height * 0.01),
                  Text(
                    widget.fileName ?? 'No file chosen',
                    style: TextStyle(color: MyColor.greyColor),
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
                  text: "Create",
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
