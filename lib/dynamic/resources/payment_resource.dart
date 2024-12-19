import 'dart:convert';

import 'package:http/http.dart';

import '../../commons/api_constants.dart';
import '../../commons/generic_response.dart';
import '../dtos/requests/payment/cancel_enrollment_request.dart';
import '../dtos/requests/payment/create_payment_request.dart';

class PaymentResource {
  // CREATE PAYMENT ---------------------------------------------------------
  Future createPayment(CreatePaymentRequest request) async {
    dynamic body = jsonEncode(request);
    Response response = await post(
        Uri.parse("${ApiConstant.backendUrl}/payment/create"),
        body: body,
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }

  // CANCEL PAYMENT ---------------------------------------------------------
  Future cancelEnrollment(CancelEnrollmentRequest request) async {
    dynamic body = jsonEncode(request);
    Response response = await post(
        Uri.parse("${ApiConstant.backendUrl}/payment/cancel-enrollment"),
        body: body,
        headers: ApiConstant.header);
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return GenericResponse.fromJson(body);
    } else {
      return GenericResponse.getFailureResponse();
    }
  }
}
