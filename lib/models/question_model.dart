import 'dart:convert';

import 'package:montanhas_quiz/models/answer_model.dart';
import 'package:montanhas_quiz/pages/home/widgets/question_tile.dart';

class QuestionModel {
  final String title;
  final String subtitle;
  final bool today;
  final String question;
  final List<AnswerModel> answers;
  final bool notAnswered;
  final String id;
  QuestionModel({
    required this.title,
    required this.subtitle,
    this.today = false,
    required this.question,
    required this.answers,
    required this.notAnswered,
    required this.id,
  });

  QuestionTile toQuestionTile() {
    return QuestionTile(
      title: title,
      subtitle: subtitle,
      today: today,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'today': today,
      'question': question,
      'id': id,
      'answers': answers.map((x) => x.toMap()).toList(),
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map, String userName) {
    return QuestionModel(
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      today: map['today'] ?? false,
      question: map['question'] ?? '',
      answers: List<AnswerModel>.from(
        map['answers']?.map(
          (x) => AnswerModel.fromMap(x),
        ),
      ),
      id: map["id"],
      notAnswered: (map["users"] as List<Map>).firstWhere((element) => element["user"] == userName).isEmpty,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuestionModel.fromJson(String source, String userName) =>
      QuestionModel.fromMap(json.decode(source), userName);
}
