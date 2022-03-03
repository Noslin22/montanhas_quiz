import 'package:flutter/material.dart';

import 'package:montanhas_quiz/models/answer_model.dart';

class AnswerTile extends StatelessWidget {
  const AnswerTile({
    Key? key,
    required this.onChanged,
    required this.model,
    required this.groupValue,
    required this.value,
  }) : super(key: key);
  final Function(int?) onChanged;
  final AnswerModel model;
  final int? groupValue;
  final int value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(model.text, style: Theme.of(context).textTheme.headline3),
      trailing: Radio<int>(
        onChanged: onChanged,
        value: value,
        groupValue: groupValue,
      ),
    );
  }
}
