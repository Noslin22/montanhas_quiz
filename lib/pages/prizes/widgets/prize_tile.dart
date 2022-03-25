import 'package:flutter/material.dart';

class PrizeTile extends StatelessWidget {
  const PrizeTile({
    Key? key,
    required this.src,
    required this.name,
  }) : super(key: key);
  final String src;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Image.network(src), Text(name)],
    );
  }
}
