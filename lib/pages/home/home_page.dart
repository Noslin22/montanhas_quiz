import 'package:flutter/material.dart';

import 'package:montanhas_quiz/models/answer_model.dart';
import 'package:montanhas_quiz/models/question_model.dart';
import 'package:montanhas_quiz/models/user_model.dart';
import 'package:montanhas_quiz/pages/home/widgets/percent_card.dart';
import 'package:montanhas_quiz/pages/quiz/quiz_page.dart';
import 'package:montanhas_quiz/server/database_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    required this.user,
  }) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Olá, ${user.nome}",
          style: Theme.of(context).textTheme.headline1!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 17,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            PercentCard(
              value: user.percentNotifier,
            ),
            Flexible(
              child: StreamBuilder<List<QuestionModel>?>(
                  stream: DatabaseProvider().getQuestions(user).asStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          snapshot.error!.toString(),
                        ),
                      );
                    } else if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData && snapshot.data == null) {
                      return const Center(
                        child: Text("Sem Perguntas :("),
                      );
                    } else {
                      List<QuestionModel> questions = snapshot.data!;
                      return ListView.builder(
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          QuestionModel model =
                              questions.reversed.toList()[index];
                          Widget questionTile = model.toQuestionTile()
                            ..onTap = () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => QuizPage(
                                    model: model,
                                    number: questions.length - index,
                                  ),
                                ),
                              );
                            };
                          if (index == 0) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Quiz de Hoje",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                  ),
                                  questionTile,
                                  const SizedBox(
                                    height: 12,
                                  ),
                                ],
                              ),
                            );
                          } else if (index == 1) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Quizes Passados",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                        ),
                                  ),
                                  questionTile,
                                ],
                              ),
                            );
                          } else {
                            return questionTile;
                          }
                        },
                        shrinkWrap: true,
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
