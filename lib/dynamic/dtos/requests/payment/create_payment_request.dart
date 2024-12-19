import 'dart:convert';

CreatePaymentRequest createPaymentRequestFromJson(String str) =>
    CreatePaymentRequest.fromJson(json.decode(str));

String createPaymentRequestToJson(CreatePaymentRequest data) =>
    json.encode(data.toJson());

class CreatePaymentRequest {
  String nameOnCard;
  String cardNumber;
  String cvc;
  String expiryMonth;
  String expiryYear;
  String payment;
  int studentId;
  int courseId;

  CreatePaymentRequest({
    required this.nameOnCard,
    required this.cardNumber,
    required this.cvc,
    required this.expiryMonth,
    required this.expiryYear,
    required this.payment,
    required this.studentId,
    required this.courseId,
  });

  factory CreatePaymentRequest.fromJson(Map<String, dynamic> json) =>
      CreatePaymentRequest(
        nameOnCard: json["nameOnCard"],
        cardNumber: json["cardNumber"],
        cvc: json["cvc"],
        expiryMonth: json["expiryMonth"],
        expiryYear: json["expiryYear"],
        payment: json["payment"],
        studentId: json["studentId"],
        courseId: json["courseId"],
      );

  Map<String, dynamic> toJson() => {
        "nameOnCard": nameOnCard,
        "cardNumber": cardNumber,
        "cvc": cvc,
        "expiryMonth": expiryMonth,
        "expiryYear": expiryYear,
        "payment": payment,
        "studentId": studentId,
        "courseId": courseId,
      };
}
