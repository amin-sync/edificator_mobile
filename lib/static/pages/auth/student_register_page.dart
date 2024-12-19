// ignore_for_file: prefer_const_constructors

import 'package:edificators_hub_mobile/dynamic/dtos/requests/auth/student_register_request.dart';
import 'package:edificators_hub_mobile/commons/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../commons/api_constants.dart';
import '../../../dynamic/providers/auth_provider.dart';
import '../../../commons/validator.dart';
import '../../widgets/dropdown/custom_dropdown.dart';
import '../../widgets/fields/custom_field.dart';
import '../../widgets/buttons/custom_button.dart';
import 'package:edificators_hub_mobile/commons/colors.dart';

import '../../../commons/toast.dart';
import '../../../commons/transparent_loader.dart';

class StudentRegisterPage extends StatefulWidget {
  const StudentRegisterPage({super.key});

  @override
  State<StudentRegisterPage> createState() => _StudentRegisterPageState();
}

class _StudentRegisterPageState extends State<StudentRegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedClass;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> onRegisterPressed(
      BuildContext context, AuthProvider authProvider) async {
    StudentRegisterRequest request = StudentRegisterRequest(
      email: emailController.text,
      fullName: fullNameController.text,
      nic: cnicController.text,
      password: passwordController.text,
      grade: selectedClass!,
      roleId: ApiConstant.studentRoleId,
    );

    await authProvider.registerStudent(request);

    if (authProvider.getRegisterStudentState.success) {
      CustomToast.showToast("Registration successfully!");
      emailController.clear();
      fullNameController.clear();
      cnicController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      selectedClass = null;
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * 0.07),
                      Text(
                        "Register as Student",
                        style: TextStyle(
                          fontSize: 25,
                          color: MyColor.tealColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: height * 0.04),
                      CustomField(
                        label: 'Email',
                        controller: emailController,
                        validator: Validator.email,
                        inputType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: height * 0.026),
                      CustomField(
                        label: 'Full Name',
                        controller: fullNameController,
                        validator: Validator.fullName,
                        inputType: TextInputType.text,
                      ),
                      SizedBox(height: height * 0.026),
                      CustomField(
                        label: 'CNIC',
                        controller: cnicController,
                        inputType: TextInputType.number,
                        validator: Validator.cnic,
                      ),
                      SizedBox(height: height * 0.026),
                      CustomDropdown(
                        value: selectedClass,
                        options: AppConstants.classOptions,
                        label: 'Class',
                        onChanged: (value) {
                          setState(() {
                            selectedClass = value;
                          });
                        },
                        validator: Validator.classValidator,
                      ),
                      SizedBox(height: height * 0.026),
                      CustomField(
                        label: 'Password',
                        isPassword: true,

                        controller: passwordController,
                        suffixIconColor: MyColor.blueColor,
                        validator:
                            Validator.password, // Apply password validator
                        inputType: TextInputType.visiblePassword,
                      ),
                      SizedBox(height: height * 0.026),
                      CustomField(
                        label: 'Confirm Password',
                        isPassword: true,
                        controller: confirmPasswordController,
                        suffixIconColor: MyColor.blueColor,
                        validator: (value) => Validator.confirmPassword(
                            value, passwordController.text),
                        inputType: TextInputType.visiblePassword,
                      ),
                      SizedBox(height: height * 0.032),
                      SizedBox(
                        width: width,
                        child: CustomButton(
                          checkInternet: true,
                          text: 'Register',
                          onPressed: () {
                            // VALIDATION
                            if (_formKey.currentState?.validate() ?? false) {
                              // REGISTER
                              onRegisterPressed(context, authProvider);
                            }
                          },
                          backgroundColor: MyColor.tealColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          authProvider.getRegisterStudentState.isLoading
              ? TransaparentLoader()
              : Container()
        ],
      ),
    );
  }
}
