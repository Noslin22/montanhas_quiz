import 'package:flutter/material.dart';
import 'package:montanhas_quiz/global/widgets/drawer/screens.dart';
import 'package:montanhas_quiz/pages/home/home_page.dart';
import 'package:montanhas_quiz/pages/prizes/prizes.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({
    Key? key,
    required this.screen,
  }) : super(key: key);
  final Screens screen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Text(
              "Este é o Montanhas Quiz, um quiz feito especialmente para você e sua base.\nAqui você tem as perguntas diárias e os prêmios que você pode ganhar.",
              textAlign: TextAlign.right,
            ),
          ),
          screen == Screens.home
              ? Container()
              : ListTile(
                  title: const Text("Home"),
                  trailing: const Icon(Icons.home),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                      (route) => false,
                    );
                  },
                ),
          screen == Screens.prizes ? const Divider() : Container(),
          screen == Screens.prizes
              ? Container()
              : ListTile(
                  title: const Text("Prêmios"),
                  subtitle: const Text("Em Construção"),
                  trailing: const Icon(Icons.local_activity),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => Prizes(),
                      ),
                      (route) => false,
                    );
                  },
                ),
        ],
      ),
    );
  }
}
