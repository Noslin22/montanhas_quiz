import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:montanhas_quiz/global/widgets/drawer/adm_drawer.dart';
import 'package:montanhas_quiz/global/widgets/drawer/screens.dart';
import 'package:montanhas_quiz/global/widgets/drawer/user_drawer.dart';
import 'package:montanhas_quiz/models/user_model.dart';
import 'package:montanhas_quiz/pages/prizes/widgets/prize_tile.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';

class Prizes extends StatelessWidget {
  Prizes({Key? key}) : super(key: key);
  final UserModel user = AuthProvider().user!;
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: user.isAdm!
          ? const AdmDrawer(screen: Screens.prizes)
          : const UserDrawer(screen: Screens.prizes),
      appBar: AppBar(title: const Text("Prêmios")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              dragStartBehavior: DragStartBehavior.start,
              itemExtent: 150,
              controller: controller,
              shrinkWrap: true,
              children: const [
                PrizeTile(
                    src:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvNqZuzAcp_ke0p-wdTNyZSGkMHnnzKNlpkg&usqp=CAU",
                    name: "Alexa"),
                PrizeTile(
                    src:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1ckrdskZwvTFWf_Jlo_wmnLehnIN9U5oJdQ&usqp=CAU",
                    name: "Hotel"),
                PrizeTile(
                    src:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvNqZuzAcp_ke0p-wdTNyZSGkMHnnzKNlpkg&usqp=CAU",
                    name: "Alexa"),
                PrizeTile(
                    src:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1ckrdskZwvTFWf_Jlo_wmnLehnIN9U5oJdQ&usqp=CAU",
                    name: "Hotel"),
                PrizeTile(
                    src:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvNqZuzAcp_ke0p-wdTNyZSGkMHnnzKNlpkg&usqp=CAU",
                    name: "Alexa"),
                PrizeTile(
                    src:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1ckrdskZwvTFWf_Jlo_wmnLehnIN9U5oJdQ&usqp=CAU",
                    name: "Hotel"),
                PrizeTile(
                    src:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvNqZuzAcp_ke0p-wdTNyZSGkMHnnzKNlpkg&usqp=CAU",
                    name: "Alexa"),
                PrizeTile(
                    src:
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1ckrdskZwvTFWf_Jlo_wmnLehnIN9U5oJdQ&usqp=CAU",
                    name: "Hotel"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
