import 'package:edificators_hub_mobile/commons/app_constants.dart';
import 'package:edificators_hub_mobile/static/widgets/dropdown/custom_small_dropdown.dart';
import 'package:flutter/material.dart';

import '../../../commons/colors.dart';
import '../buttons/custom_small_button.dart';
import '../fields/custom_field.dart';
import '../texts/custom_text.dart';

class UploadQuizDialogue extends StatefulWidget {
  final TextEditingController uploadQuizController;

  const UploadQuizDialogue({
    Key? key,
    required this.uploadQuizController,
  }) : super(key: key);

  @override
  _UploadQuizDialogueState createState() => _UploadQuizDialogueState();
}

class _UploadQuizDialogueState extends State<UploadQuizDialogue> {
  String? selectedDuration;
  String? selecteQuestion;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    //Number of question drop down
    List<String> noOfQuestions =
        List.generate(46, (index) => (index + 5).toString());

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Center(
        child: CustomText(
          text: "Create Quiz",
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
              controller: widget.uploadQuizController,
            ),
            SizedBox(height: height * 0.02),
            CustomSmallDropdown(
              value: selectedDuration,
              options: AppConstants.durationOptions,
              label: "Duration",
              onChanged: (String? newValue) {
                setState(() {
                  selectedDuration = newValue; // Update selected grade
                });
              },
            ),
            SizedBox(height: height * 0.02),
            CustomSmallDropdown(
              value: selecteQuestion,
              options: noOfQuestions,
              label: "No .of questions",
              onChanged: (String? newValue) {
                setState(() {
                  selecteQuestion = newValue; // Update selected grade
                });
              },
            ),
            SizedBox(height: height * 0.02),
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
