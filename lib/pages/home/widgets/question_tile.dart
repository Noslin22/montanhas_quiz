import 'package:flutter/material.dart';

class QuestionTile extends StatelessWidget {
  QuestionTile({
    Key? key,
    required this.title,
    required this.subtitle,
    this.today = false,
    this.onTap,
  }) : super(key: key);
  final String title;
  final String subtitle;
  final bool today;
  VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: Theme.of(context).textTheme.headline3!.copyWith(fontSize: 15),
        ),
        textColor: Colors.black,
        visualDensity: VisualDensity.comfortable,
        onTap: onTap,
      ),
    );
  }
}
