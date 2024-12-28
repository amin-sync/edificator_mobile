import 'dart:convert';

AttemptQuizResponse attemptQuizResponseFromJson(String str) =>
    AttemptQuizResponse.fromJson(json.decode(str));

String attemptQuizResponseToJson(AttemptQuizResponse data) =>
    json.encode(data.toJson());

class AttemptQuizResponse {
  String question;
  int questionId;
  String answer1;
  int answer1Id;
  String answer2;
  int answer2Id;
  String? answer3;
  int answer3Id;
  String? answer4;
  int answer4Id;
  String duration;

  AttemptQuizResponse({
    required this.question,
    required this.questionId,
    required this.answer1,
    required this.answer1Id,
    required this.answer2,
    required this.answer2Id,
    required this.answer3,
    required this.answer3Id,
    required this.answer4,
    required this.answer4Id,
    required this.duration,
  });

  factory AttemptQuizResponse.fromJson(Map<String, dynamic> json) =>
      AttemptQuizResponse(
        question: json["question"],
        questionId: json["questionId"],
        answer1: json["answer1"],
        answer1Id: json["answer1Id"],
        answer2: json["answer2"],
        answer2Id: json["answer2Id"],
        answer3: json["answer3"],
        answer3Id: json["answer3Id"],
        answer4: json["answer4"],
        answer4Id: json["answer4Id"],
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "questionId": questionId,
        "answer1": answer1,
        "answer1Id": answer1Id,
        "answer2": answer2,
        "answer2Id": answer2Id,
        "answer3": answer3,
        "answer3Id": answer3Id,
        "answer4": answer4,
        "answer4Id": answer4Id,
        "duration": duration,
      };
}
