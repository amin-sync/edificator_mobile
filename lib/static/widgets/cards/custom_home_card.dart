import 'package:flutter/material.dart';

import '../../../commons/colors.dart';
import '../texts/custom_text.dart';

class CustomHomeCard extends StatefulWidget {
  final String name;
  final String count1;
  final String count2;
  final String text1;
  final String text2;
  CustomHomeCard(
      {super.key,
      required this.count1,
      required this.count2,
      required this.name,
      required this.text1,
      required this.text2});

  @override
  State<CustomHomeCard> createState() => _CustomHomeCardState();
}

class _CustomHomeCardState extends State<CustomHomeCard> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: "Welcome",
              fontSize: 15,
              color: MyColor.greyColor,
              fontWeight: FontWeight.w400,
            ),
            SizedBox(height: height * 0.006),
            CustomText(
              text: widget.name,
              fontSize: 22,
              color: MyColor.blueColor,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: height * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                countCard(widget.count1, widget.text1),
                SizedBox(width: width * 0.03),
                countCard(widget.count2, widget.text2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget countCard(String count, String text) {
    var height = MediaQuery.of(context).size.height;
    return Expanded(
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              CustomText(
                text: count,
                fontSize: 18,
                color: MyColor.blueColor,
                fontWeight: FontWeight.w900,
              ),
              SizedBox(height: height * 0.008),
              CustomText(
                text: text,
                fontSize: 15,
                color: MyColor.greyColor,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
