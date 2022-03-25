import 'package:flutter/material.dart';

// ignore: must_be_immutable
class QuestionTile extends StatelessWidget {
  QuestionTile({
    Key? key,
    required this.title,
    required this.subtitle,
    this.today = false,
    this.answered = false,
    this.onTap,
  }) : super(key: key);
  final String title;
  final String subtitle;
  final bool today;
  final bool answered;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListTile(
            title: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              subtitle,
              style:
                  Theme.of(context).textTheme.headline3!.copyWith(fontSize: 15),
            ),
            textColor: Colors.black,
            visualDensity: VisualDensity.comfortable,
            onTap: onTap,
          ),
        ),
        answered
            ? const Icon(
                Icons.check_rounded,
                color: Colors.green,
              )
            : Container()
      ],
    );
  }
}
