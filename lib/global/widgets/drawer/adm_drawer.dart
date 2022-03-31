import 'package:flutter/material.dart';
import 'package:montanhas_quiz/pages/home/home_page.dart';
import 'package:montanhas_quiz/pages/manage_questions/manage_questions.dart';
import 'package:montanhas_quiz/pages/manage_users/manage_users.dart';
import 'package:montanhas_quiz/pages/prizes/prizes.dart';
import 'package:montanhas_quiz/pages/rank/rank_page.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';
import 'package:montanhas_quiz/server/database_provider.dart';

import 'screens.dart';

class AdmDrawer extends StatelessWidget {
  const AdmDrawer({
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
              "Bem Vindo a área de administração\nAqui você pode adicionar, remover ou editar as perguntas e ver o Rank Geral",
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
          screen == Screens.home || screen == Screens.questions
              ? Container()
              : const Divider(),
          screen == Screens.questions
              ? Container()
              : ListTile(
                  title: const Text("Gerenciar Perguntas"),
                  trailing: const Icon(Icons.add),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const ManageQuestions(),
                      ),
                      (route) => false,
                    );
                  },
                ),
          screen == Screens.rank ? Container() : const Divider(),
          screen == Screens.rank
              ? Container()
              : ListTile(
                  title: const Text("Rank Geral"),
                  trailing: const Icon(Icons.bar_chart),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => RankPage(
                          user: AuthProvider().user!,
                        ),
                      ),
                      (route) => false,
                    );
                  },
                ),
          screen == Screens.users ? Container() : const Divider(),
          screen == Screens.users
              ? Container()
              : AuthProvider().user!.email != "nilson@gmail.com" &&
                      AuthProvider().user!.email != "denissondias@bol.com.br"
                  ? Container()
                  : ListTile(
                      title: const Text("Gerenciar Usuários"),
                      subtitle: const Text("Em Construção"),
                      trailing: const Icon(Icons.people),
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const ManageUsers(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
          // screen == Screens.prizes ? Container() : const Divider(),
          // screen == Screens.prizes
          //     ? Container()
          //     : ListTile(
          //         title: const Text("Prêmios"),
          //         subtitle: const Text("Em Construção"),
          //         trailing: const Icon(Icons.local_activity),
          //         onTap: () {
          //           Navigator.of(context).pushAndRemoveUntil(
          //             MaterialPageRoute(
          //               builder: (context) => Prizes(),
          //             ),
          //             (route) => false,
          //           );
          //         },
          //       ),
          const Spacer(),
          const Divider(color: Colors.red),
          ListTile(
            title: const Text("Limpar Semana"),
            trailing: const Icon(Icons.delete_forever),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text("Deseja limpar a semana?"),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (_) => const Center(
                                  child: CircularProgressIndicator()),
                            );
                            await DatabaseProvider()
                                .cleanQuestions(AuthProvider().user!)
                                .then(
                              (value) {
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              },
                            );
                          },
                          child: const Text("Sim"),
                          style: TextButton.styleFrom(
                            primary: Colors.grey[700],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Não"),
                        ),
                      ],
                    );
                  });
            },
          ),
          const Divider(color: Colors.red),
        ],
      ),
    );
  }
}
