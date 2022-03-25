import 'dart:convert';

class AnswerModel {
  final String text;
  final bool isCorrect;
  AnswerModel({
    required this.text,
    this.isCorrect = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isCorrect': isCorrect,
    };
  }

  factory AnswerModel.fromMap(Map<String, dynamic> map) {
    return AnswerModel(
      text: map['text'] ?? '',
      isCorrect: map['isCorrect'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory AnswerModel.fromJson(String source) =>
      AnswerModel.fromMap(json.decode(source));

  AnswerModel copyWith({
    String? text,
    bool? isCorrect,
  }) {
    return AnswerModel(
      text: text ?? this.text,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  @override
  String toString() => 'AnswerModel(text: $text, isCorrect: $isCorrect)';
}
