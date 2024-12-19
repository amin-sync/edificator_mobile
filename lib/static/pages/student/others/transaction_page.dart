import 'package:edificators_hub_mobile/static/pages/student/student_dashboard/student_dashboard_page.dart';
import 'package:flutter/material.dart';

import '../../../../commons/colors.dart';
import '../../../widgets/buttons/custom_button.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.whiteColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: MyColor.tealColor,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(40),
              child: Icon(
                Icons.check,
                color: MyColor.whiteColor,
                size: 70,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Transaction Successful",
              style: TextStyle(
                color: MyColor.tealColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: MyColor.whiteColor,
        elevation: 8.0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: CustomButton(
            text: 'Back to application',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => StudentDashboardPage()),
                (Route<dynamic> route) => false, // Removes all previous routes
              );
            },
            backgroundColor: MyColor.tealColor,
          ),
        ),
      ),
    );
  }
}
