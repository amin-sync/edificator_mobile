// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:edificators_hub_mobile/commons/api_constants.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/requests/auth/teacher_regitser_request.dart';
import 'package:edificators_hub_mobile/commons/validator.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../../dynamic/providers/auth_provider.dart';
import '../../../commons/colors.dart';
import '../../widgets/buttons/custom_button.dart';
import '../../widgets/buttons/custom_small_button.dart';
import '../../widgets/fields/custom_field.dart';
import '../../../commons/toast.dart';
import '../../../commons/transparent_loader.dart';
import '../../widgets/texts/custom_text.dart';

class TeacherRegisterPage extends StatefulWidget {
  const TeacherRegisterPage({Key? key}) : super(key: key);

  @override
  State<TeacherRegisterPage> createState() => _TeacherRegisterPageState();
}

class _TeacherRegisterPageState extends State<TeacherRegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController yourExpertiseController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String? fileName;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
      });
    } else {
      setState(() {
        fileName = 'No file selected';
      });
    }
  }

  Future<void> onRegisterPressed(
      BuildContext context, AuthProvider authProvider) async {
    TeacherRegisterRequest request = TeacherRegisterRequest(
      email: emailController.text,
      fullName: fullNameController.text,
      nic: cnicController.text,
      expertise: yourExpertiseController.text,
      password: passwordController.text,
      roleId: ApiConstant.teacherRoleId,
    );

    await authProvider.registerTeacher(request);

    if (authProvider.getRegisterTeacherState.success) {
      CustomToast.showToast("Registration successfully!");
      emailController.clear();
      fullNameController.clear();
      cnicController.clear();
      yourExpertiseController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    } else {
      CustomToast.showDangerToast("Registration failed. Try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * 0.07),
                    CustomText(
                      text: "Register as Teacher",
                      fontSize: 22,
                      color: MyColor.tealColor,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(height: height * 0.03),
                    CustomField(
                      label: 'Email',
                      controller: emailController,
                      validator: Validator.email,
                      inputType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: height * 0.024),
                    CustomField(
                      label: 'Full Name',
                      controller: fullNameController,
                      validator: Validator.fullName,
                      inputType: TextInputType.text,
                    ),
                    SizedBox(height: height * 0.027),
                    CustomField(
                      label: 'CNIC',
                      controller: cnicController,
                      inputType: TextInputType.number,
                      validator: Validator.cnic,
                    ),
                    SizedBox(height: height * 0.027),
                    CustomField(
                      label: 'Your Expertise',
                      controller: yourExpertiseController,
                      validator: Validator.yourExpertise,
                    ),
                    SizedBox(height: height * 0.027),
                    CustomField(
                      label: 'Password',
                      isPassword: true,
                      controller: passwordController,
                      suffixIconColor: MyColor.blueColor,
                      validator: Validator.password,
                      inputType: TextInputType.visiblePassword,
                    ),
                    SizedBox(height: height * 0.027),
                    CustomField(
                      label: 'Confirm Password',
                      isPassword: true,
                      controller: confirmPasswordController,
                      suffixIconColor: MyColor.blueColor,
                      validator: (value) => Validator.confirmPassword(
                          value, passwordController.text),
                      inputType: TextInputType.visiblePassword,
                    ),
                    SizedBox(height: height * 0.027),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Upload your Resume:',
                            fontSize: 16,
                            color: MyColor.blueColor,
                          ),
                          SizedBox(height: height * 0.01),
                          CustomSmallButton(
                            text: "Choose File",
                            onPressed: pickFile,
                            backgroundColor: MyColor.blueColor,
                          ),
                          SizedBox(height: height * 0.01),
                          Text(
                            fileName ?? 'No file chosen',
                            style: TextStyle(color: MyColor.greyColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.027),
                    SizedBox(
                        width: width,
                        child: CustomButton(
                          checkInternet: true,
                          backgroundColor: MyColor.tealColor,
                          text: 'Register',
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              if (fileName == null ||
                                  fileName == 'No file selected') {
                                CustomToast.showDangerToast(
                                    "Upload your resume.");
                              } else {
                                // REGISTER
                                onRegisterPressed(context, authProvider);
                              }
                            }
                          },
                        )),
                  ],
                ),
              ),
            ),
          ),
          authProvider.getRegisterTeacherState.isLoading
              ? TransaparentLoader()
              : Container()
        ],
      ),
    );
  }
}
