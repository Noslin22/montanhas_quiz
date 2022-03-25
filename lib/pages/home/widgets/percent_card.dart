import 'package:flutter/material.dart';
import 'package:montanhas_quiz/models/user_model.dart';

import 'percent_indicator.dart';

class PercentCard extends StatelessWidget {
  final ValueNotifier<UserModel?> percent;
  const PercentCard({
    Key? key,
    required this.percent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: ValueListenableBuilder<UserModel?>(
                valueListenable: percent,
                builder: (_, user, __) {
                  return PercentIndicator(value: user!.percent!);
                }
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Vamos Começar",
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Text(
                    "Todo dia uma nova pergunta é liberada para você checar seus conhecimentos",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
