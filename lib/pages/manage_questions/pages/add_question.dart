import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:montanhas_quiz/global/widgets/field.dart';
import 'package:montanhas_quiz/models/answer_model.dart';
import 'package:montanhas_quiz/models/question_model.dart';
import 'package:montanhas_quiz/global/extensions/captalize.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';
import 'package:montanhas_quiz/server/database_provider.dart';
import 'package:montanhas_quiz/global/utils/message_snackbar.dart';

class AddQuestion extends StatefulWidget {
  const AddQuestion({Key? key}) : super(key: key);

  @override
  State<AddQuestion> createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final List<FocusNode> focusNodes = List.generate(8, (index) => FocusNode());
  QuestionModel question = QuestionModel.empty();

  final _formKey = GlobalKey<FormState>();

  int correctAnswer = 0;

  void changeAnswer(int? value) {
    int currentAnswer =
        question.answers.lastIndexWhere((element) => element.isCorrect);
    setState(() {
      correctAnswer = value ?? 0;
    });
    question.answers[currentAnswer] =
        question.answers[currentAnswer].copyWith(isCorrect: false);
    question.answers[correctAnswer] =
        question.answers[correctAnswer].copyWith(isCorrect: true);
  }

  Future<void> submit() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      await DatabaseProvider()
          .addQuestion(
              AuthProvider().user!,
              {
                "title": question.title,
                "subtitle": question.subtitle,
                'question': question.question,
                'answers': question.answers
                    .map((e) => {"text": e.text, "isCorrect": e.isCorrect})
                    .toList(),
                "users": [],
              },
              context)
          .then((value) {
        Navigator.pop(context);
        if (value) {
          _formKey.currentState!.reset();
          question = QuestionModel.empty();
          MessageSnackBar(
                  context: context, message: "Pergunta adicionada com sucesso")
              .showMessage();
        } else {
          MessageSnackBar(
            context: context,
            message: "Ocorreu um problema, tente novamente",
          ).showMessage();
        }
      });
      setState(() {});
    }
  }

  void datePicker() {
    showDatePicker(
      context: context,
      fieldLabelText: "Selecione uma data",
      confirmText: "Confirmar",
      cancelText: "Cancelar",
      initialDate: DateTime.now(),
      firstDate: DateTime.parse("${DateTime.now().year}-01-01"),
      lastDate: DateTime.parse("${DateTime.now().year}-12-31"),
    ).then(
      (value) {
        if (value == null) {
          MessageSnackBar(
            context: context,
            message: "Por favor, selecione uma data",
          ).showMessage();
        } else {
          question = question.copyWith(
            subtitle: DateFormat("EEEE d/MM/y").format(value).capitalize() ??
                DateFormat("EEEE dd/MM/y").format(value),
          );
          List<String> pieces = question.subtitle!.split(" ");
          if (pieces[1].split("/")[0].length == 1) {
            setState(() {
              question = question.copyWith(
                subtitle:
                    "${pieces[0]} 0${pieces[1].split("/")[0]}/${pieces[1].substring(2)}",
              );
            });
          }
          FocusScope.of(context).requestFocus(focusNodes[3]);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Field(
              focus: focusNodes[0],
              onComplete: datePicker,
              action: TextInputAction.next,
              onSaved: (text) {
                question = question.copyWith(title: text);
              },
              type: TextInputType.name,
              label: "Titulo",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Este campo é obrigatório";
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Field(
                focus: focusNodes[2],
                onTap: datePicker,
                type: TextInputType.name,
                value: question.subtitle ?? "",
                action: TextInputAction.next,
                label: "Data da Pergunta",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Este campo é obrigatório";
                  }
                  return null;
                },
              ),
            ),
            Field(
              focus: focusNodes[3],
              onComplete: () {
                FocusScope.of(context).requestFocus(focusNodes[4]);
              },
              action: TextInputAction.next,
              type: TextInputType.name,
              onSaved: (text) {
                question = question.copyWith(question: text);
              },
              label: "Pergunta",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Este campo é obrigatório";
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Field(
                      focus: focusNodes[4],
                      onComplete: () {
                        FocusScope.of(context).requestFocus(focusNodes[5]);
                      },
                      type: TextInputType.name,
                      action: TextInputAction.next,
                      onSaved: (text) {
                        question.answers[0] = AnswerModel(
                          text: text!,
                          isCorrect: correctAnswer == 0,
                        );
                      },
                      label: "Resposta 1",
                      showError: true,
                      suffix: Radio(
                        value: 0,
                        groupValue: correctAnswer,
                        onChanged: changeAnswer,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Field(
                      focus: focusNodes[5],
                      onComplete: () {
                        FocusScope.of(context).requestFocus(focusNodes[6]);
                      },
                      type: TextInputType.name,
                      action: TextInputAction.next,
                      onSaved: (text) {
                        question.answers[1] = AnswerModel(
                          text: text!,
                          isCorrect: correctAnswer == 1,
                        );
                      },
                      label: "Resposta 2",
                      showError: true,
                      suffix: Radio(
                        value: 1,
                        groupValue: correctAnswer,
                        onChanged: changeAnswer,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Field(
                    focus: focusNodes[6],
                    onComplete: () {
                      FocusScope.of(context).requestFocus(focusNodes[7]);
                    },
                    action: TextInputAction.next,
                    type: TextInputType.name,
                    onSaved: (text) {
                      question.answers[2] = AnswerModel(
                        text: text!,
                        isCorrect: correctAnswer == 2,
                      );
                    },
                    label: "Resposta 3",
                    showError: false,
                    suffix: SizedBox.square(
                      dimension: 15,
                      child: Radio(
                        value: 2,
                        groupValue: correctAnswer,
                        onChanged: changeAnswer,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Field(
                    focus: focusNodes[7],
                    onComplete: () {
                      FocusScope.of(context).unfocus();
                      submit();
                    },
                    action: TextInputAction.done,
                    type: TextInputType.name,
                    onChanged: (text) {
                      _formKey.currentState!.save();
                    },
                    onSaved: (text) {
                      question.answers[3] = AnswerModel(
                        text: text!,
                        isCorrect: correctAnswer == 3,
                      );
                    },
                    label: "Resposta 4",
                    showError: false,
                    suffix: SizedBox.square(
                      dimension: 15,
                      child: Radio(
                        value: 3,
                        groupValue: correctAnswer,
                        onChanged: changeAnswer,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                child: const Text("Adicionar"),
                onPressed: question.complete ? submit : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
