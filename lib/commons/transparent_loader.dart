// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:edificators_hub_mobile/static/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TransaparentLoader extends StatelessWidget {
  const TransaparentLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blur the background
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0.2), // Semi-transparent overlay
          ),
        ),
        // Centered Loader
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SpinKitWaveSpinner(
                color: MyColor.blueColor,
                trackColor: MyColor.greyColor,
                waveColor: MyColor.tealColor,
                size: 50.0,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            CustomText(
                text: "Please wait.", fontSize: 16, color: MyColor.tealColor)
          ],
        ),
      ],
    );
  }
}
