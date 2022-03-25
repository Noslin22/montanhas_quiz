import 'package:flutter/material.dart';
import 'package:montanhas_quiz/global/extensions/percent.dart';

class PercentIndicator extends StatelessWidget {
  const PercentIndicator({
    Key? key,
    required this.value,
  }) : super(key: key);
  final double value;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: SizedBox(
            width: 70,
            height: 70,
            child: CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation(Colors.green),
              value: value,
              strokeWidth: 6,
              backgroundColor: Colors.grey[200],
            ),
          ),
        ),
        Text(
          value.percent(),
          style: Theme.of(context).textTheme.headline1,
        ),
      ],
    );
  }
}
