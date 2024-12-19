import 'package:edificators_hub_mobile/dynamic/dtos/requests/course/create_course_request.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/requests/course/update_course_request.dart';
import 'package:edificators_hub_mobile/commons/shared_pref.dart';
import 'package:edificators_hub_mobile/commons/toast.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import '../../../commons/validator.dart';
import '../../../dynamic/dtos/responses/course/teacher_course_list_response.dart';
import '../../../dynamic/providers/course_provider.dart';
import '../../../dynamic/providers/dashboard_provider.dart';
import '../../../commons/app_constants.dart';
import '../../../commons/colors.dart';
import '../dropdown/custom_dropdown.dart';
import '../fields/custom_field.dart';
import '../texts/custom_text.dart';

class CustomCourseDialogue extends StatefulWidget {
  final String title;
  final bool isCreate;
  final TeacherCourseListResponse? course;

  CustomCourseDialogue(
      {super.key,
      required this.isCreate,
      required this.title,
      required this.course});

  @override
  // ignore: library_private_types_in_public_api
  _CustomCourseDialogueState createState() => _CustomCourseDialogueState();
}

class _CustomCourseDialogueState extends State<CustomCourseDialogue> {
  final TextEditingController feeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedClass;
  String? selectedSubject;
  String? selectedFromTime;
  String? selectedToTime;
  List<String> selectedDays = ['Monday'];

  @override
  void initState() {
    super.initState();

    if (!widget.isCreate) {
      // Initialize variables using response
      feeController.text = widget.course!.fee;
      selectedClass = widget.course!.grade;
      selectedSubject = widget.course!.subject;
      selectedFromTime = widget.course!.fromTime;
      selectedToTime = widget.course!.toTime;
      selectedDays = widget.course!.days.split(',');
    }
  }

  String getSelectedDaysText() {
    if (selectedDays.isEmpty) {
      return "";
    }
    return selectedDays.join(",");
  }

  onOkPressed(BuildContext context, TeacherCourseListResponse? course) async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final dashboardProvider =
        Provider.of<DashboardProvider>(context, listen: false);
    if (widget.isCreate) {
      int teacherId = await SharedPref().readInt("associateId");
      CreateCourseRequest request = CreateCourseRequest(
          grade: selectedClass ?? "",
          subject: selectedSubject ?? "",
          days: getSelectedDaysText(),
          fromTime: selectedFromTime ?? "",
          toTime: selectedToTime ?? "",
          fee: feeController.text,
          teacherId: teacherId);

      await courseProvider.createCourse(request);
      if (courseProvider.getCreateCourseState.success) {
        courseProvider.listTeacherCourse();
        dashboardProvider.getTeacherDashboard();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        CustomToast.showToast("Course created successfully");
      } else {
        CustomToast.showToast("Error creating course");
      }
    } else {
      UpdateCourseRequest request = UpdateCourseRequest(
          grade: selectedClass!,
          subject: selectedSubject!,
          days: getSelectedDaysText(),
          fromTime: selectedFromTime!,
          toTime: selectedToTime!,
          fee: feeController.text,
          courseId: course!.id);
      await courseProvider.updateCourse(request);
      if (courseProvider.getUpdateCourseState.success) {
        courseProvider.listTeacherCourse();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        CustomToast.showToast("Course updated successfully");
      } else {
        CustomToast.showToast("Error updating course");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: CustomText(
          text: widget.title,
          fontSize: 22,
          color: MyColor.tealColor,
          fontWeight: FontWeight.w700,
        ),
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Class Dropdown
                CustomDropdown(
                  validator: Validator.classValidator,
                  value: selectedClass,
                  options: AppConstants.classOptions,
                  label: 'Class',
                  onChanged: (value) => setState(() => selectedClass = value),
                ),
                SizedBox(height: height * 0.022),

                // Subject Dropdown
                CustomDropdown(
                  validator: Validator.subjectValidator,
                  value: selectedSubject,
                  options: AppConstants.subjectOptions,
                  label: 'Subject',
                  onChanged: (value) => setState(() => selectedSubject = value),
                ),
                SizedBox(height: height * 0.022),

                // Days Selector
                GestureDetector(
                  onTap: () async {
                    final updatedDays = await showDialog<List<String>>(
                      context: context,
                      builder: (BuildContext context) {
                        List<String> tempSelectedDays = List.from(
                            selectedDays); // Start with current values
                        return StatefulBuilder(
                          builder: (context, setStateDialog) {
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
                                      title: Text(
                                        day,
                                        style:
                                            TextStyle(color: MyColor.blueColor),
                                      ),
                                      value: tempSelectedDays.contains(
                                          day), // Show checked if already selected
                                      onChanged: (bool? isChecked) {
                                        setStateDialog(() {
                                          if (isChecked == true) {
                                            tempSelectedDays
                                                .add(day); // Add day if checked
                                          } else {
                                            tempSelectedDays.remove(
                                                day); // Remove day if unchecked
                                          }
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
                                    Navigator.pop(context,
                                        tempSelectedDays); // Return updated list
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );

                    // Update parent state with selected days
                    if (updatedDays != null) {
                      setState(() {
                        selectedDays = updatedDays; // Reflect changes in parent
                      });
                    }
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
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

                // From Time Dropdown
                CustomDropdown(
                  validator: Validator.fromTimeValidator,
                  value: selectedFromTime,
                  options: AppConstants.fromTime,
                  label: 'From Time',
                  onChanged: (value) =>
                      setState(() => selectedFromTime = value),
                ),
                SizedBox(height: height * 0.022),

                // To Time Dropdown
                CustomDropdown(
                  validator: Validator.toTimeValidator,
                  value: selectedToTime,
                  options: AppConstants.toTime,
                  label: 'To Time',
                  onChanged: (value) => setState(() => selectedToTime = value),
                ),
                SizedBox(height: height * 0.022),

                // Fee Field
                CustomField(
                  validator: Validator.feeValidator,
                  label: 'Fee',
                  controller: feeController,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: CustomText(
              text: "Cancel",
              color: MyColor.blueColor,
              fontSize: 15,
            ),
          ),
          TextButton(
            onPressed: () async {
              // VALIDATION

              // INTERNET
              if (await InternetConnectionChecker().hasConnection) {
                // VALIDATE
                if (_formKey.currentState?.validate() ?? false) {
                  if (selectedDays.isEmpty) {
                    CustomToast.showDangerToast("Please specify days");
                  } else {
                    // CREATE
                    onOkPressed(context, widget.course ?? null);
                  }
                }
              } else {
                CustomToast.showDangerToast("No internet connected");
              }
            },
            child: CustomText(
              text: widget.isCreate ? "Create" : "Update",
              color: MyColor.blueColor,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
