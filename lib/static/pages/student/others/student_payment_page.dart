import 'package:edificators_hub_mobile/commons/validator.dart';
import 'package:edificators_hub_mobile/dynamic/dtos/requests/payment/create_payment_request.dart';
import 'package:edificators_hub_mobile/dynamic/providers/payment_provider.dart';
import 'package:edificators_hub_mobile/static/pages/student/others/transaction_page.dart';
import 'package:edificators_hub_mobile/static/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../commons/colors.dart';
import '../../../../commons/shared_pref.dart';
import '../../../../commons/toast.dart';
import '../../../widgets/fields/custom_field.dart';
import '../../../widgets/texts/custom_text.dart';
import '../../../../commons/image_utils.dart';
import 'dart:async'; // For Timer

class StudentPaymentPage extends StatefulWidget {
  final int courseId;
  final String fee;
  const StudentPaymentPage(
      {super.key, required this.courseId, required this.fee});

  @override
  State<StudentPaymentPage> createState() => _StudentPaymentPageState();
}

class _StudentPaymentPageState extends State<StudentPaymentPage> {
  onPayPressed(BuildContext context) async {
    final paymentProvider =
        Provider.of<PaymentProvider>(context, listen: false);

    int studentId = await SharedPref().readInt("associateId");
    CreatePaymentRequest request = CreatePaymentRequest(
        payment: widget.fee,
        studentId: studentId,
        courseId: widget.courseId,
        nameOnCard: nameController.text,
        cardNumber: cardNumberController.text,
        cvc: cvcController.text,
        expiryMonth: selectedMonth!,
        expiryYear: selectedYear!);

    await paymentProvider.createPayment(request);
    if (paymentProvider.getCreatePayementState.success) {
      _showProcessingDialog();
    } else {
      CustomToast.showToast("Transaction failed");
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedMonth;
  String? selectedYear;

  final List<String> months =
      List.generate(12, (index) => (index + 1).toString().padLeft(2, '0'));
  final List<String> years =
      List.generate(10, (index) => (2024 + index).toString());

  void _showProcessingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TransactionPage()),
          );
        });
        return Dialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: MyColor.blueColor,
                ),
                SizedBox(height: 20),
                CustomText(
                  text: "Processing",
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: MyColor.blueColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: CustomText(
          text: "Payment",
          fontSize: 22,
          color: MyColor.tealColor,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: MyColor.blueColor),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey, // Wrap with Form widget
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(image: AssetImage(ImageUtils.visa), width: 100),
                    Image(image: AssetImage(ImageUtils.masterCard), width: 100),
                  ],
                ),
                SizedBox(height: height * 0.012),
                Center(
                  child: CustomText(
                    text: "Pay with your Visa / MasterCard",
                    fontSize: 18,
                    color: MyColor.tealColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: height * 0.04),
                CustomField(
                  label: 'Name on Card',
                  controller: nameController,
                  inputType: TextInputType.text,
                  validator: Validator.fullName,
                ),
                SizedBox(height: height * 0.02),
                CustomField(
                  label: 'Card Number',
                  controller: cardNumberController,
                  inputType: TextInputType.number,
                  validator: Validator.cardNumber,
                ),
                SizedBox(height: 16),
                CustomField(
                  label: 'CVC',
                  controller: cvcController,
                  inputType: TextInputType.number,
                  validator: Validator.cvc,
                ),
                SizedBox(height: 16),
                CustomText(
                  text: "Expiry:",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: MyColor.blueColor,
                ),
                SizedBox(height: height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            labelText: 'Month',
                            labelStyle: TextStyle(color: MyColor.blueColor),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: MyColor.blueColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: MyColor.blueColor),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            filled: true),
                        value: selectedMonth,
                        items: months.map((String month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedMonth = newValue;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            labelText: 'Year',
                            labelStyle: TextStyle(color: MyColor.blueColor),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: MyColor.blueColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: MyColor.blueColor),
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            filled: true),
                        value: selectedYear,
                        items: years.map((String year) {
                          return DropdownMenuItem<String>(
                            value: year,
                            child: Text(year),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedYear = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8.0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: CustomButton(
            text: 'Pay Now',
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                if (selectedMonth == null || selectedYear == null) {
                  CustomToast.showDangerToast("Please specify expiry.");
                } else {
                  // PAYMENT
                  onPayPressed(context);
                }
              }
            },
            backgroundColor: MyColor.tealColor,
          ),
        ),
      ),
    );
  }
}
