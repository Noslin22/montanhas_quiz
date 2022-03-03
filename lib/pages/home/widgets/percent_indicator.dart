import 'package:flutter/material.dart';

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
          "${(value * 100).toStringAsFixed(2).contains(".00") ? (value * 100).toStringAsFixed(2).replaceAll(".00", "") : (value * 100).toStringAsFixed(0)}%",
          style: Theme.of(context).textTheme.headline1,
        ),
      ],
    );
  }
}
