// ignore_for_file: prefer_const_constructors

import 'package:edificators_hub_mobile/commons/api_constants.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/requests/auth/login_request.dart';
import 'package:edificators_hub_mobile/static/pages/auth/student_register_page.dart';
import 'package:edificators_hub_mobile/static/pages/auth/teacher_register_page.dart';
import 'package:edificators_hub_mobile/static/pages/student/student_dashboard/student_dashboard_page.dart';
import 'package:edificators_hub_mobile/commons/image_utils.dart';
import 'package:edificators_hub_mobile/commons/validator.dart';
import 'package:edificators_hub_mobile/commons/transparent_loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../dynamic/providers/auth_provider.dart';
import '../../widgets/fields/custom_field.dart';
import '../../../commons/toast.dart';
import '../../widgets/texts/custom_text.dart';
import '../../widgets/buttons/custom_button.dart';
import 'package:edificators_hub_mobile/commons/colors.dart';

import '../teacher/teacher_dashboard/teacher_dashboard_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> onLoginPressed(
      BuildContext context, AuthProvider authProvider) async {
    LoginRequest request = LoginRequest(
      email: emailController.text,
      password: passwordController.text,
    );

    await authProvider.login(request);

    if (authProvider.getLoginState.success) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => authProvider.getLoginState.response!.roleId ==
                  ApiConstant.teacherRoleId
              ? TeacherDashboardPage()
              : StudentDashboardPage(),
        ),
      );
      CustomToast.showToast("Login successfull!");
    } else {
      CustomToast.showDangerToast("Login failed. Try again.");
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
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey, // Wrap with Form widget
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * 0.027),
                    Center(
                      child: Image.asset(
                        ImageUtils.appLogo, // Replace with your image path
                        height: height * 0.23, // Increased image size
                      ),
                    ),

                    SizedBox(
                        height: height *
                            0.027), // Reduced space between image and text

                    // Login text in the middle
                    CustomText(
                      text: "Login to your account",
                      fontSize: 22,
                      color: MyColor.tealColor,
                      fontWeight: FontWeight.w700,
                    ),
                    SizedBox(
                        height: height *
                            0.04), // Reduced space between text and fields

                    // Email and Password Text Fields
                    CustomField(
                        label: 'Email',
                        controller: emailController,
                        inputType: TextInputType.emailAddress,
                        validator: Validator.email // Set validator for email
                        ),
                    SizedBox(height: height * 0.027),
                    CustomField(
                      label: 'Password',
                      isPassword: true,
                      inputType: TextInputType.visiblePassword,
                      controller: passwordController,
                      suffixIconColor: MyColor.blueColor,
                      validator: Validator.password,
                    ),
                    SizedBox(height: height * 0.027),

                    // Login Button
                    SizedBox(
                      width: width,
                      child: CustomButton(
                        checkInternet: true,
                        text: 'Login',
                        onPressed: () {
                          // VALIDATE
                          if (_formKey.currentState?.validate() ?? false) {
                            // LOGIN
                            onLoginPressed(context, authProvider);
                          }
                        },
                        backgroundColor: MyColor.blueColor,
                      ),
                    ),
                    SizedBox(height: height * 0.027),

                    CustomText(
                      text: "Don't have an account?",
                      fontSize: 15,
                      color: MyColor.blueColor,
                    ),

                    SizedBox(height: height * 0.027),

                    // Register as Teacher Button
                    SizedBox(
                      width: width,
                      child: CustomButton(
                        text: 'Register as Teacher',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  TeacherRegisterPage(), // Replace with actual screen
                            ),
                          );
                        },
                        backgroundColor: MyColor.tealColor,
                      ),
                    ),
                    SizedBox(height: height * 0.02),

                    // Divider with "or" text
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: MyColor.greyColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            "or",
                            style: TextStyle(
                              color: MyColor.greyColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color: MyColor.greyColor,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: height * 0.02),

                    // Register as Student Button
                    SizedBox(
                      width: width,
                      child: CustomButton(
                        text: 'Register as Student',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StudentRegisterPage(), // Replace with actual screen
                            ),
                          );
                        },
                        backgroundColor: MyColor.tealColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          authProvider.getLoginState.isLoading
              ? TransaparentLoader()
              : Container()
        ],
      ),
    );
  }
}
