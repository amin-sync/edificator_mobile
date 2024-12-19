// ignore_for_file: prefer_const_constructors

import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:edificators_hub_mobile/static/widgets/texts/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        CustomText(text: "Please wait.", fontSize: 16, color: MyColor.tealColor)
      ],
    );
  }
}
