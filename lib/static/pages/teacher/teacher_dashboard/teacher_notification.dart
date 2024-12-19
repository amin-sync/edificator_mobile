// // ignore_for_file: prefer_const_constructors

// import 'package:edificators_hub_mobile/commons/app_constants.dart';
// import 'package:edificators_hub_mobile/commons/colors.dart';
// import 'package:edificators_hub_mobile/static/widgets/texts/custom_text.dart';
// import 'package:flutter/material.dart';

// import '../../../../commons/image_utils.dart';

// class TeacherNotification extends StatefulWidget {
//   const TeacherNotification({super.key});

//   @override
//   State<TeacherNotification> createState() => _TeacherNotificationState();
// }

// class _TeacherNotificationState extends State<TeacherNotification> {
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(5),
//         child: SafeArea(
//           child: Column(
//             children: [
//               SizedBox(height: height * 0.02),
//               Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(Icons.arrow_back, color: MyColor.blueColor),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                   SizedBox(width: width * 0.2),
//                   CustomText(
//                     text: "Notifications",
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: MyColor.blueColor,
//                   ),
//                 ],
//               ),
//               SizedBox(height: height * 0.02),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: AppConstants.notifications.length,
//                   itemBuilder: (context, index) {
//                     final notification = AppConstants.notifications[index];
//                     return Column(
//                       children: [
//                         ListTile(
//                           leading: Container(
//                             width: 60, // Adjusted width for profile picture
//                             height: 60, // Matching height for a circular avatar
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: MyColor.blueColor,
//                                 width: 2, // Adjusted border width
//                               ),
//                             ),
//                             child: CircleAvatar(
//                               radius: 28, // Avatar size inside the container
//                               backgroundColor: Colors.transparent,
//                               backgroundImage: AssetImage(ImageUtils
//                                   .profilePicture), // Your image asset
//                             ),
//                           ),
//                           title: CustomText(
//                             text: notification['title'],
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600,
//                             color: MyColor.blackColor,
//                           ),
//                           subtitle: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 notification['description'],
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           trailing: Text(
//                             notification['dateTime'],
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[500],
//                             ),
//                           ),
//                         ),
//                         Divider(thickness: 1, indent: 70, endIndent: 10),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
