// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:edificators_hub_mobile/static/pages/auth/login_page.dart';
import 'package:edificators_hub_mobile/commons/image_utils.dart';
import 'package:edificators_hub_mobile/static/widgets/profile_options/custom_profile.dart';

import 'package:flutter/material.dart';
import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:edificators_hub_mobile/static/widgets/texts/custom_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';

import '../../../widgets/fields/custom_field.dart';

class StudentAccountPage extends StatefulWidget {
  const StudentAccountPage({super.key});

  @override
  State<StudentAccountPage> createState() => _StudentAccountPageState();
}

class _StudentAccountPageState extends State<StudentAccountPage> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  //GALLERY
  Future _pickImageFromGallery() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
  }

  // CAMERA
  Future _pickImageFromCamera() async {
    var image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.03),
              CustomText(
                text: "Account",
                fontSize: 22,
                color: MyColor.tealColor,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: height * 0.06),
              Stack(
                children: [
                  Container(
                    width: width * 0.30,
                    height: width * 0.30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: MyColor.blueColor, width: 3),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      backgroundImage: _image == null
                          ? AssetImage(ImageUtils.profilePicture)
                              as ImageProvider<Object>
                          : FileImage(File(_image!.path)),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        _pickImageFromCamera();
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
                        _pickImageFromGallery();
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
                  text: "Wajiha", fontSize: 22, color: MyColor.blueColor),
              SizedBox(height: height * 0.01),
              CustomText(
                  text: "wajiha123@gmail.com",
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

  void _showChangePasswordDialog(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
                  ),
                  SizedBox(height: height * 0.02),
                  CustomField(
                    label: 'New Password',
                    isPassword: true,
                    suffixIconColor: MyColor.blueColor,
                  ),
                  SizedBox(height: height * 0.02),
                  CustomField(
                    label: 'Confirm Password',
                    isPassword: true,
                    suffixIconColor: MyColor.blueColor,
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
                Navigator.of(context).pop();
                showToast("Password has been changed");
              },
              child: CustomText(
                  text: "Ok", fontSize: 15, color: MyColor.blueColor),
            ),
          ],
        );
      },
    );
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: MyColor.blackColor,
      textColor: MyColor.whiteColor,
      fontSize: 16.0,
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
          fontSize: 20,
          color: MyColor.blueColor,
          fontWeight: FontWeight.bold,
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              ); // Dismiss dialog
            },
            child: CustomText(
              text: "Yes",
              color: MyColor.blueColor,
              fontSize: 15,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
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
