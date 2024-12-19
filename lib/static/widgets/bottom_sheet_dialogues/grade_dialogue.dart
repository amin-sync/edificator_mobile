import 'package:edificators_hub_mobile/commons/validator.dart';
import 'package:flutter/material.dart';
import '../../../commons/colors.dart';
import '../buttons/custom_icon_button.dart';
import '../buttons/custom_small_button.dart';
import '../dropdown/custom_small_dropdown.dart';
import '../texts/custom_text.dart';

class GradeDialog extends StatefulWidget {
  final Function onSubmit; // Callback for submit action
  final Function onCancel; // Callback for cancel action

  GradeDialog({
    Key? key,
    required this.onSubmit,
    required this.onCancel,
  }) : super(key: key);

  @override
  _GradeDialogState createState() => _GradeDialogState();
}

class _GradeDialogState extends State<GradeDialog> {
  final _formKey = GlobalKey<FormState>();
  String? selectedGrade; // Track selected grade

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    // Create a list of grade options from 1 to 10
    List<String> gradeOptions =
        List.generate(10, (index) => (index + 1).toString());

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Center(
        child: CustomText(
          text: "Grade",
          color: MyColor.blueColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey, // Assign the form key
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconButton(
                text: "Download",
                icon: Icons.download,
                backgroundColor: MyColor.tealColor,
                textColor: MyColor.whiteColor,
                onPressed: () {}, // Implement download functionality if needed
              ),
              SizedBox(height: height * 0.02),
              CustomSmallDropdown(
                value: selectedGrade,
                options: gradeOptions,
                label: "Grade",
                onChanged: (String? newValue) {
                  setState(() {
                    selectedGrade = newValue; // Update selected grade
                  });
                },
                validator: Validator.gradeValidator,
              ),
              SizedBox(height: height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomSmallButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cancel action
                    },
                    text: "Cancel",
                    textColor: MyColor.tealColor,
                    backgroundColor: MyColor.whiteColor,
                  ),
                  CustomSmallButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, call the submit callback
                        widget.onSubmit(selectedGrade);
                        Navigator.of(context)
                            .pop(); // Close dialog after submission
                      }
                    },
                    text: "Submit",
                    backgroundColor: MyColor.tealColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
