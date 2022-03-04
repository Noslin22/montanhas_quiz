import 'package:flutter/material.dart';

import 'package:montanhas_quiz/models/question_model.dart';
import 'package:montanhas_quiz/models/user_model.dart';
import 'package:montanhas_quiz/pages/quiz/widgets/answer_tile.dart';
import 'package:montanhas_quiz/pages/quiz/widgets/result_page.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';
import 'package:montanhas_quiz/server/database_provider.dart';
import 'package:montanhas_quiz/utils/message_snackbar.dart';

class QuizPage extends StatefulWidget {
  QuizPage({
    Key? key,
    required this.model,
    required this.number,
  }) : super(key: key);
  final QuestionModel model;
  final int number;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int? _answer;

  void setAnswer(int? value) {
    setState(() {
      _answer = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Pergunta ${widget.number}"),
                const Text("de 7"),
              ],
            ),
            const SizedBox(
              height: 64,
            ),
            Flexible(
                child: Text(widget.model.question,
                    style: Theme.of(context).textTheme.headline4)),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              flex: 10,
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return AnswerTile(
                    onChanged: setAnswer,
                    model: widget.model.answers[index],
                    groupValue: _answer,
                    value: index,
                  );
                },
                itemCount: widget.model.answers.length,
                shrinkWrap: true,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _answer != null
                  ? () async {
                      int correctAnswer = widget.model.answers.indexWhere(
                        (element) => element.isCorrect,
                      );
                      UserModel user = AuthProvider().user;
                      double percent = double.parse((1 / 7).toStringAsFixed(4));
                      if (_answer == correctAnswer) {
                        user.percent += percent;
                        await DatabaseProvider().rightQuestion(user);

                        if (user.percent + percent >= 1) {
                          MessageSnackBar(
                            context: context,
                            message: "Você acertou todas!!!",
                          ).showMessage();
                        } else {}
                      }
                      if (await DatabaseProvider()
                          .doneQuestion(user, widget.model)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultPage(
                              win: _answer == correctAnswer,
                            ),
                          ),
                        );
                      }
                    }
                  : null,
              child: const Text("Confirmar"),
              style: ElevatedButton.styleFrom(primary: Colors.green),
            )
          ],
        ),
      ),
    );
  }
}
