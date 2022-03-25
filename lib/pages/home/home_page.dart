import 'package:flutter/material.dart';
import 'package:montanhas_quiz/global/widgets/drawer/adm_drawer.dart';
import 'package:montanhas_quiz/global/widgets/drawer/screens.dart';
import 'package:montanhas_quiz/global/widgets/drawer/user_drawer.dart';
import 'package:montanhas_quiz/models/user_model.dart';
import 'package:montanhas_quiz/pages/home/widgets/percent_card.dart';
import 'package:montanhas_quiz/pages/home/widgets/question_list.dart';
import 'package:montanhas_quiz/pages/login/login_page.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UserModel?>(
        valueListenable: AuthProvider.userNotifier,
        builder: (context, user, _) {
          return Scaffold(
            appBar: AppBar(
              title: GestureDetector(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Deseja realmente sair?"),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            prefs.clear();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: const Text("Sim"),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  "Olá, ${user!.nome}",
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 17,
                      ),
                ),
              ),
            ),
            drawer: user.isAdm!
                ? const AdmDrawer(
                    screen: Screens.home,
                  )
                : null,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  PercentCard(
                    percent: AuthProvider.userNotifier,
                  ),
                  Flexible(
                    child: QuestionList(
                      user: user,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
