// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/requests/user/update_password_request.dart';
import 'package:edificators_hub_mobile/commons/shared_pref.dart';
import 'package:edificators_hub_mobile/static/pages/auth/login_page.dart';
import 'package:edificators_hub_mobile/commons/image_utils.dart';
import 'package:edificators_hub_mobile/static/widgets/profile_options/custom_profile.dart';

import 'package:flutter/material.dart';
import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:edificators_hub_mobile/static/widgets/texts/custom_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../dynamic/dtos/responses/user_profile_response.dart';
import '../../../../dynamic/providers/user_provider.dart';
import '../../../../commons/validator.dart';
import '../../../widgets/fields/custom_field.dart';
import '../../../../commons/toast.dart';
import '../../../../commons/loader.dart';

class TeacherAccountPage extends StatefulWidget {
  const TeacherAccountPage({super.key});

  @override
  State<TeacherAccountPage> createState() => _TeacherAccountPageState();
}

class _TeacherAccountPageState extends State<TeacherAccountPage> {
  // INITIAL CALL
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.getUserProfileState.response?.profileUrl == null) {
        userProvider.getUserProfile();
      }
    });
  }

  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    // USER PROFILE
    final userProvider = Provider.of<UserProvider>(context);
    UserProfileResponse? userProfile =
        userProvider.getUserProfileState.response;
    return userProvider.getUserProfileState.isLoading
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              title: CustomText(
                text: "Account",
                fontSize: 22,
                color: MyColor.tealColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.03),
                    Stack(
                      children: [
                        Container(
                            width: width * 0.30,
                            height: width * 0.30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: MyColor.blueColor, width: 3),
                            ),
                            child: (userProvider
                                        .getUploadProfilePicState.isLoading ||
                                    userProvider.getUserProfileState.isLoading)
                                ? Center(child: CircularProgressIndicator())
                                : CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: _image != null
                                        ? FileImage(File(_image!.path))
                                        : userProfile?.profileUrl == null
                                            ? AssetImage(
                                                ImageUtils.profilePicture)
                                            : CachedNetworkImageProvider(
                                                "${userProfile?.profileUrl}?t=${DateTime.now().millisecondsSinceEpoch}",
                                              ) as ImageProvider<Object>,
                                  )),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              _pickImage(ImageSource.camera);
                            },
                            child: CircleAvatar(
                              backgroundColor: MyColor.tealColor,
                              radius: 16,
                              child: Icon(Icons.camera_enhance_rounded,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: GestureDetector(
                            onTap: () {
                              _pickImage(ImageSource.gallery);
                            },
                            child: CircleAvatar(
                              backgroundColor: MyColor.tealColor,
                              radius: 16,
                              child: Icon(Icons.photo_library,
                                  color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    CustomText(
                        text: userProfile?.fullName ?? "--",
                        fontSize: 22,
                        color: MyColor.blueColor),
                    SizedBox(height: height * 0.01),
                    CustomText(
                        text: userProfile?.email ?? "--",
                        fontSize: 15,
                        color: MyColor.greyColor),
                    SizedBox(height: height * 0.03),
                    CustomProfile(
                      icon: Icons.lock,
                      text: "Change Password",
                      textColor: MyColor.blueColor,
                      onTap: () {
                        _showChangePasswordDialog(context);
                      },
                    ),
                    CustomProfile(
                      icon: Icons.info_outline,
                      text: "About Us",
                      textColor: MyColor.blueColor,
                      onTap: () {
                        _showAboutUsDialog(context);
                      },
                    ),
                    CustomProfile(
                      icon: Icons.power_settings_new,
                      text: "Logout",
                      textColor: MyColor.blueColor,
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  // IMAGE PICKER
  Future _pickImage(ImageSource source) async {
    print("CHECK");
    var image = await _picker.pickImage(source: source);
    setState(() {
      _image = image;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.uploadProfilePic(_image!);
  }

  //Api call method for update password
  Future<void> onUpdatePasswordDialoguePressed(
      BuildContext context, UserProvider userProvider) async {
    int userId = await SharedPref().readInt("userId");
    UpdatePasswordRequest request = UpdatePasswordRequest(
        oldPassword: currentPasswordController.text,
        newPassword: newPasswordController.text,
        userId: userId);

    await userProvider.updatePassword(request);
    if (userProvider.getUpdatePasswordState.success) {
      await SharedPref().saveBool("isLogin", false);
      CustomToast.showToast("Password has been updated!");
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
      CustomToast.showToast("Please login with the new password");
    } else {
      CustomToast.showDangerToast("Error upadting passsword");
    }
  }

// UPDATE DIALOG
  void _showChangePasswordDialog(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    var height = MediaQuery.of(context).size.height;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: _formKey,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            title: CustomText(
              text: "Change Password",
              fontSize: 22,
              color: MyColor.tealColor,
              fontWeight: FontWeight.w700,
            ),
            content: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              // height: height * 0.27,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: height * 0.02),
                    CustomField(
                      label: 'Current Password',
                      isPassword: true,
                      suffixIconColor: MyColor.blueColor,
                      controller: currentPasswordController,
                      validator: Validator.password,
                    ),
                    SizedBox(height: height * 0.02),
                    CustomField(
                      label: 'New Password',
                      isPassword: true,
                      suffixIconColor: MyColor.blueColor,
                      controller: newPasswordController,
                      validator: Validator.password,
                    ),
                    SizedBox(height: height * 0.02),
                    CustomField(
                      label: 'Confirm Password',
                      isPassword: true,
                      suffixIconColor: MyColor.blueColor,
                      controller: confirmPasswordController,
                      validator: (value) => Validator.confirmPassword(
                          value, newPasswordController.text),
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
                    text: "Cancel", fontSize: 15, color: MyColor.blueColor),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    onUpdatePasswordDialoguePressed(context, userProvider);
                  }
                },
                child: CustomText(
                    text: "Ok", fontSize: 15, color: MyColor.blueColor),
              ),
            ],
          ),
        );
      },
    );
  }
}

void _showAboutUsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: CustomText(
          text: "Edificators Hub",
          fontSize: 22,
          color: MyColor.tealColor,
          fontWeight: FontWeight.w700,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text:
                  "Edificators Hub is a platform designed to enhance the learning experience by providing various resources and tools for students and educators. Our goal is to facilitate knowledge sharing and improve educational outcomes.",
              fontSize: 14,
              color: MyColor.greyColor,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: CustomText(
                text: "Close", fontSize: 15, color: MyColor.blueColor),
          ),
        ],
      );
    },
  );
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: CustomText(
          text: "Logout",
          fontSize: 22,
          color: MyColor.tealColor,
          fontWeight: FontWeight.w700,
        ),
        content: CustomText(
            text: "Are you sure ?", color: MyColor.blueColor, fontSize: 15),
        actions: [
          TextButton(
            onPressed: () async {
              await SharedPref().saveBool("isLogin", false);
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: CustomText(
              text: "Yes",
              color: MyColor.blueColor,
              fontSize: 15,
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: CustomText(
              text: "No",
              color: MyColor.blueColor,
              fontSize: 15,
            ),
          ),
        ],
      );
    },
  );
}
