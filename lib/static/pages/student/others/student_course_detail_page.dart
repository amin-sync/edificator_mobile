// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/requests/payment/cancel_enrollment_request.dart';
import 'package:edificators_hub_mobile/static/pages/student/others/student_payment_page.dart';
import 'package:flutter/material.dart';
import 'package:edificators_hub_mobile/commons/colors.dart';
import 'package:provider/provider.dart';
import '../../../../commons/image_utils.dart';
import '../../../../commons/loader.dart';
import '../../../../commons/shared_pref.dart';
import '../../../../commons/toast.dart';
import '../../../../dynamic/dtos/responses/course/course_detail_response.dart';
import '../../../../dynamic/providers/course_provider.dart';
import '../../../../dynamic/providers/enrollment_provider.dart';
import '../../../../dynamic/providers/payment_provider.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/cards/status_card.dart';
import '../../../widgets/texts/custom_text.dart';

class StudentCourseDetailPage extends StatefulWidget {
  final bool isEnabled;
  final int courseId;

  const StudentCourseDetailPage(
      {super.key, this.isEnabled = false, required this.courseId});

  @override
  State<StudentCourseDetailPage> createState() =>
      _StudentCourseDetailPageState();
}

class _StudentCourseDetailPageState extends State<StudentCourseDetailPage> {
  onCancelEnrollment(BuildContext context) async {
    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);

    int studentId = await SharedPref().readInt("associateId");
    CancelEnrollmentRequest request = CancelEnrollmentRequest(
      studentId: studentId,
      courseId: widget.courseId,
    );

    await paymentProvider.cancelEnrollment(request);
    if (paymentProvider.getCancelPayementState.success) {
      final enrollementProvider =
          Provider.of<EnrollmentProvider>(context, listen: false);
      enrollementProvider.listEnrolledCourses();
      Navigator.pop(context);
      CustomToast.showToast("Subscription cancelled successfully.");
    } else {
      CustomToast.showDangerToast("Error cancelling subscription.");
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // GET DETAIL
    final courseProvider = Provider.of<CourseProvider>(context);
    CourseDetailResponse? courseDetail =
        courseProvider.getCourseDetailState.response;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomText(
          text: "Details",
          fontSize: 22,
          color: MyColor.tealColor,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: MyColor.blueColor),
      ),
      body: (courseProvider.getCourseDetailState.isLoading)
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Teacher Info Card
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width * 0.25,
                            height: width * 0.25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: MyColor.blueColor,
                                width: 1.5,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: courseDetail?.profileUrl == null
                                  ? AssetImage(ImageUtils.profilePicture)
                                  : CachedNetworkImageProvider(
                                      "${courseDetail?.profileUrl}?t=${DateTime.now().millisecondsSinceEpoch}",
                                    ) as ImageProvider<Object>,
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                          CustomText(
                            text: courseDetail?.fullName ?? "",
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: MyColor.tealColor,
                          ),
                          SizedBox(height: height * 0.002),
                          CustomText(
                            text: courseDetail?.expertise ?? "",
                            fontSize: 15,
                            color: MyColor.greyColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.018), // Spacing between cards
                  // Course Details Heading
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: CustomText(
                        text: "Course Details",
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: MyColor.blueColor,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.018),
                  // Course Details Card
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5.0,
                    child: SizedBox(
                      width: width * 0.9, // Set fixed width for both cards
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  text: courseDetail?.subject ?? "",
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: MyColor.tealColor,
                                ),
                                CustomStatusCard(
                                  text: "PKR ${courseDetail?.fee ?? ""}",
                                  backgroundColor:
                                      Colors.green[100]!, // Background color
                                  textColor: MyColor.greenColor, // Text color
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.01),
                            CustomText(
                              text: courseDetail?.grade ?? "",
                              fontSize: 15,
                              color: MyColor.greyColor,
                            ),
                            SizedBox(height: height * 0.01),
                            CustomText(
                              text: courseDetail?.days ?? "",
                              fontSize: 15,
                              color: MyColor.greyColor,
                            ),
                            SizedBox(height: height * 0.01),
                            CustomText(
                              text:
                                  "Timing: ${courseDetail?.fromTime} to ${courseDetail?.toTime}",
                              fontSize: 15,
                              color: MyColor.greyColor,
                            ),
                            SizedBox(height: height * 0.01),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8.0,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: CustomButton(
              text: widget.isEnabled ? 'Cancel Subscription' : 'Enroll',
              onPressed: () {
                if (widget.isEnabled) {
                  onCancelEnrollment(context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StudentPaymentPage(
                          courseId: widget.courseId,
                          fee: courseDetail?.fee ?? ""),
                    ),
                  );
                }
              },
              backgroundColor: MyColor.tealColor,
            )),
      ),
    );
  }
}
