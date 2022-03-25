import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:montanhas_quiz/global/extensions/percent.dart';

class RankTile extends StatelessWidget {
  const RankTile({
    Key? key,
    required this.name,
    required this.percent,
  }) : super(key: key);
  final String name;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: LayoutBuilder(
        builder: (context, constraints) => SizedBox(
          width: constraints.biggest.width * percent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0).copyWith(top: 20),
                    child: Text(
                      name,
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    percent.percent(),
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 2),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  color: Colors.green,
                  height: 20,
                  width: constraints.biggest.width * percent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    // LinearProgressIndicator(
    //   color: Colors.green,
    //   minHeight: 25,
    //   valueColor: const AlwaysStoppedAnimation(Colors.green),
    //   value: value,
    //   backgroundColor: Colors.grey[200],
    // );
  }
}
