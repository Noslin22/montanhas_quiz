import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:montanhas_quiz/models/question_model.dart';
import 'package:montanhas_quiz/models/user_model.dart';
import 'package:montanhas_quiz/pages/quiz/widgets/answer_tile.dart';
import 'package:montanhas_quiz/pages/quiz/widgets/result_page.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';
import 'package:montanhas_quiz/server/database_provider.dart';
import 'package:montanhas_quiz/global/utils/message_snackbar.dart';

import '../../global/utils/loading_dialog.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({
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
  late Timer timer;
  int counter = 15;

  @override
  void initState() {
    widget.model.answers.shuffle(Random(2204));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    startTimer();
    super.didChangeDependencies();
  }

  void setAnswer(int? value) {
    setState(() {
      _answer = value;
    });
  }

  void startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (counter == 0) {
          setState(() {
            timer.cancel();
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ResultPage(
                win: false,
              ),
            ),
          );
        } else {
          setState(() {
            counter--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 22),
                child: Text(counter.toString()),
              ),
              Flexible(
                  child: Text(widget.model.question!,
                      style: Theme.of(context).textTheme.headline4)),
              const SizedBox(height: 24),
              Expanded(
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
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: _answer != null
                ? () async {
                    int correctAnswer = widget.model.answers.indexWhere(
                      (element) => element.isCorrect,
                    );
                    UserModel user = AuthProvider().user!;
                    double percent = double.parse((1 / 7).toStringAsFixed(4));

                    LoadingDialog.showLoading(context);
                    if (_answer == correctAnswer) {
                      if (user.percent!.toInt() + percent.toInt() >= 1) {
                        MessageSnackBar(
                          context: context,
                          message: "Você acertou todas!!!",
                        ).showMessage();
                      } else {
                        AuthProvider().user =
                            user.copyWith(percent: user.percent! + percent);
                        user = AuthProvider().user!;
                        await DatabaseProvider().rightQuestion(user);
                      }
                      Navigator.pop(context);
                    }
                    if (await DatabaseProvider()
                        .doneQuestion(user, widget.model)) {
                      Navigator.pop(context);
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
          ),
        ),
      ),
    );
  }
}
