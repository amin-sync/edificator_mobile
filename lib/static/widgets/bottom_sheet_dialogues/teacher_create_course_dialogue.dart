import 'package:flutter/material.dart';
import 'package:edificators_hub_mobile/commons/app_constants.dart';
import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:edificators_hub_mobile/static/widgets/fields/custom_field.dart';
import 'package:edificators_hub_mobile/static/widgets/texts/custom_text.dart';
import 'package:edificators_hub_mobile/static/widgets/dropdown/custom_dropdown.dart';

class TeacherCreateCourseDialog extends StatefulWidget {
  final String? selectedClass;
  final String? selectedSubject;
  final String? selectedFromTime;
  final String? selectedToTime;
  final List<String> selectedDays;
  final TextEditingController feeController;
  final VoidCallback onSave;

  const TeacherCreateCourseDialog({
    super.key,
    required this.selectedClass,
    required this.selectedSubject,
    required this.selectedFromTime,
    required this.selectedToTime,
    required this.selectedDays,
    required this.feeController,
    required this.onSave,
  });

  @override
  _TeacherCreateCourseDialogState createState() =>
      _TeacherCreateCourseDialogState();
}

class _TeacherCreateCourseDialogState extends State<TeacherCreateCourseDialog> {
  late String? _selectedClass;
  late String? _selectedSubject;
  late String? _selectedFromTime;
  late String? _selectedToTime;
  late List<String> _selectedDays;

  @override
  void initState() {
    super.initState();
    _selectedClass = widget.selectedClass;
    _selectedSubject = widget.selectedSubject;
    _selectedFromTime = widget.selectedFromTime;
    _selectedToTime = widget.selectedToTime;
    _selectedDays =
        List.from(widget.selectedDays); // Create a copy of the selected days
  }

  String getSelectedDaysText() {
    if (_selectedDays.isEmpty) return "";
    if (_selectedDays.length <= 3) return _selectedDays.join(", ");
    return "${_selectedDays.take(3).join(", ")}...";
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: CustomText(
        text: "Update Course",
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: MyColor.blueColor,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            CustomDropdown(
              value: _selectedClass,
              options: AppConstants.classOptions,
              label: 'Class',
              onChanged: (value) {
                setState(() {
                  _selectedClass = value;
                });
              },
            ),
            SizedBox(height: height * 0.022),
            CustomDropdown(
              value: _selectedSubject,
              options: AppConstants.subjectOptions,
              label: 'Subject',
              onChanged: (value) {
                setState(() {
                  _selectedSubject = value;
                });
              },
            ),
            SizedBox(height: height * 0.022),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(builder: (context, setStateDialog) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        title: CustomText(
                          text: "Select Days",
                          color: MyColor.blueColor,
                          fontSize: 16,
                        ),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: AppConstants.daysOptions.map((day) {
                              return CheckboxListTile(
                                activeColor: MyColor.blueColor,
                                title: Text(day,
                                    style: TextStyle(color: MyColor.blueColor)),
                                value: _selectedDays.contains(day),
                                onChanged: (bool? isChecked) {
                                  setStateDialog(() {
                                    if (isChecked == true) {
                                      _selectedDays.add(day);
                                    } else {
                                      _selectedDays.remove(day);
                                    }
                                    setState(() {}); // Update parent state
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            child: CustomText(
                              text: "Ok",
                              color: MyColor.blueColor,
                              fontSize: 16,
                            ),
                            onPressed: () {
                              setState(() {}); // Update parent state
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
                  },
                );
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Days',
                  labelStyle: TextStyle(color: MyColor.blueColor),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: MyColor.blueColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: MyColor.blueColor),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  filled: true,
                  fillColor: Colors.white,
                ),
                child: Text(
                  getSelectedDaysText(),
                  style: TextStyle(color: MyColor.blueColor),
                ),
              ),
            ),
            SizedBox(height: height * 0.022),
            CustomDropdown(
              value: _selectedFromTime,
              options: AppConstants.fromTime,
              label: 'From Time',
              onChanged: (value) {
                setState(() {
                  _selectedFromTime = value;
                });
              },
            ),
            SizedBox(height: height * 0.022),
            CustomDropdown(
              value: _selectedToTime,
              options: AppConstants.toTime,
              label: 'To Time',
              onChanged: (value) {
                setState(() {
                  _selectedToTime = value;
                });
              },
            ),
            SizedBox(height: height * 0.022),
            CustomField(
              label: 'Fee',
              controller: widget.feeController,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: CustomText(
            fontWeight: FontWeight.bold,
            text: "Cancel",
            color: MyColor.blueColor,
            fontSize: 16,
          ),
        ),
        TextButton(
          onPressed: () {
            // Call the onSave callback with the updated values
            widget.onSave();
            Navigator.of(context).pop();
          },
          child: CustomText(
            fontWeight: FontWeight.bold,
            text: "Create Course",
            color: MyColor.blueColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
