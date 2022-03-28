import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:montanhas_quiz/models/answer_model.dart';
import 'package:montanhas_quiz/pages/home/widgets/question_tile.dart';

class QuestionModel {
  final String? title;
  final String? subtitle;
  final String? question;
  final List<AnswerModel> answers;
  final bool? notAnswered;
  final bool? correct;
  final String? id;
  QuestionModel({
    this.title,
    this.subtitle,
    this.question,
    required this.answers,
    this.notAnswered,
    this.correct,
    this.id,
  });

  QuestionTile toQuestionTile() {
    List<String> date = subtitle!.split(" ")[1].split("/");
    List<int> today = [
      DateTime.now().day,
      DateTime.now().month,
      DateTime.now().year
    ];

    return QuestionTile(
      title: title!,
      subtitle: subtitle!,
      today: today.map((e) => e.toString()) == date,
      answered: !notAnswered!,
      correct: correct!,
    );
  }

  QuestionModel copyWith({
    String? title,
    String? subtitle,
    String? question,
    List<AnswerModel>? answers,
    bool? notAnswered,
    bool? correct,
    String? id,
  }) {
    return QuestionModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      question: question ?? this.question,
      answers: answers ?? this.answers,
      notAnswered: notAnswered ?? this.notAnswered,
      correct: correct ?? this.correct,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'question': question,
      'id': id,
      'answers': answers.map((x) => x.toMap()).toList(),
      'notAnswered': notAnswered,
    };
  }

  factory QuestionModel.fromMap(Map<String, dynamic> map, String userName) {
    return QuestionModel(
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      question: map['question'] ?? '',
      correct: (map["users"] as List<dynamic>).firstWhere(
            (element) => element["user"] == userName,
            orElse: () => {},
          )["correct"] ??
          false,
      answers: List<AnswerModel>.from(
        map['answers']?.map(
              (x) => AnswerModel.fromMap(x),
            ) ??
            [],
      ),
      id: map["id"],
      notAnswered: (map["users"] as List<dynamic>)
          .firstWhere(
            (element) => element["user"] == userName,
            orElse: () => [],
          )
          .isEmpty,
    );
  }

  factory QuestionModel.empty() => QuestionModel(
      answers: List<AnswerModel>.filled(4, AnswerModel(text: "")));

  String toJson() => json.encode(toMap());

  factory QuestionModel.fromJson(String source, String userName) =>
      QuestionModel.fromMap(json.decode(source), userName);

  bool get complete =>
      title != null &&
      subtitle != null &&
      answers.length == 4 &&
      question != null;

  @override
  String toString() {
    return 'QuestionModel(title: $title, subtitle: $subtitle, question: $question, answers: $answers, notAnswered: $notAnswered, correct: $correct, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuestionModel &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.question == question &&
        listEquals(other.answers, answers) &&
        other.notAnswered == notAnswered &&
        other.correct == correct &&
        other.id == id;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        subtitle.hashCode ^
        question.hashCode ^
        answers.hashCode ^
        notAnswered.hashCode ^
        correct.hashCode ^
        id.hashCode;
  }
}
