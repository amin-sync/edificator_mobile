import 'package:edificators_hub_mobile/dynamic/resources/payment_resource.dart';
import 'package:flutter/material.dart';

import '../../commons/generic_response.dart';
import '../../commons/provider_state.dart';
import '../dtos/requests/payment/cancel_enrollment_request.dart';
import '../dtos/requests/payment/create_payment_request.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentResource paymentResource = PaymentResource();
  GenericResponse? genericResponse;

  ProviderState createPayementState = ProviderState();
  ProviderState cancelPayementState = ProviderState();

  ProviderState get getCreatePayementState => createPayementState;
  ProviderState get getCancelPayementState => cancelPayementState;

  // CREATE PAYMENT ---------------------------------------------------------
  Future<void> createPayment(CreatePaymentRequest request) async {
    createPayementState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await paymentResource.createPayment(request);
      createPayementState = ProviderState(
          isLoading: false, success: genericResponse!.success, response: null);
    } catch (e) {
      createPayementState = ProviderState(isLoading: false, success: false);
    } finally {
      notifyListeners();
    }
  }

  // CANCEL PAYMENT ---------------------------------------------------------
  Future<void> cancelEnrollment(CancelEnrollmentRequest request) async {
    cancelPayementState = ProviderState(isLoading: true);
    notifyListeners();

    try {
      genericResponse = await paymentResource.cancelEnrollment(request);
      cancelPayementState = ProviderState(
          isLoading: false, success: genericResponse!.success, response: null);
    } catch (e) {
      cancelPayementState = ProviderState(isLoading: false, success: false);
    } finally {
      notifyListeners();
    }
  }
}
