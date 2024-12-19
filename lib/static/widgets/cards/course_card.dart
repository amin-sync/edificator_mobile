import 'package:flutter/material.dart';
import '../../../commons/colors.dart';
import '../texts/custom_text.dart';

class CourseCard extends StatelessWidget {
  final Map<String, String> course;
  final Function onEdit;
  final Function onTap;

  const CourseCard({
    Key? key,
    required this.course,
    required this.onEdit,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(course['title']!),
      direction: DismissDirection.startToEnd, // Swipe left to right
      onDismissed: (direction) {
        // Handle course deletion here
      },
      background: Container(
        decoration: BoxDecoration(
          color: MyColor.redColor,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: MyColor.whiteColor),
      ),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        color: MyColor.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: MyColor.blueColor),
        ),
        child: ListTile(
          title: CustomText(
            text: course['title']!,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: MyColor.tealColor,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Class: ${course['class']}",
                fontSize: 15,
                color: MyColor.tealColor,
              ),
              CustomText(
                text: "Fee: ${course['fee']}",
                fontSize: 15,
                color: MyColor.tealColor,
              ),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.edit, color: MyColor.blueColor),
            onPressed: () => onEdit(course),
          ),
          onTap: () => onTap(),
        ),
      ),
    );
  }
}
