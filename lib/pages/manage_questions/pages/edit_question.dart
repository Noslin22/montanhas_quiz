import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:montanhas_quiz/global/extensions/captalize.dart';
import 'package:montanhas_quiz/global/utils/message_snackbar.dart';
import 'package:montanhas_quiz/global/widgets/field.dart';
import 'package:montanhas_quiz/models/answer_model.dart';
import 'package:montanhas_quiz/models/question_model.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';
import 'package:montanhas_quiz/server/database_provider.dart';

class EditQuestion extends StatefulWidget {
  const EditQuestion({Key? key}) : super(key: key);

  @override
  State<EditQuestion> createState() => _EditQuestionState();
}

class _EditQuestionState extends State<EditQuestion> {
  final List<FocusNode> focusNodes = List.generate(8, (index) => FocusNode());
  QuestionModel question = QuestionModel.empty();
  late Future<List<QuestionModel>> questions;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    questions = DatabaseProvider().listQuestions(AuthProvider().user!);
  }

  int correctAnswer = 0;

  void changeAnswer(int? value) {
    setState(() {
      correctAnswer = value ?? 0;
    });
  }

  Future<void> submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      showDialog(
        context: context,
        barrierDismissible: false,
        useSafeArea: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
      await DatabaseProvider()
          .editQuestion(AuthProvider().user!, question)
          .then((value) {
        Navigator.pop(context);
        if (value) {
          _formKey.currentState!.reset();
          question = QuestionModel.empty();
          MessageSnackBar(
                  context: context, message: "Pergunta editada com sucesso")
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
            FutureBuilder<List<QuestionModel>>(
                future: questions,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return DropdownButtonFormField<QuestionModel>(
                      focusNode: focusNodes[0],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      items: snapshot.data!
                          .map((e) => DropdownMenuItem(
                                child: Text(
                                  e.title!,
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          question = value!;
                          correctAnswer = value.answers
                              .indexWhere((element) => element.isCorrect);
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Questão",
                        labelStyle: GoogleFonts.roboto(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value == QuestionModel.empty()) {
                          return "Escolha uma questão";
                        }
                        return null;
                      },
                    );
                  } else {
                    return const LinearProgressIndicator();
                  }
                }),
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
              value: question.question ?? "",
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
                        question.answers.insert(
                            0,
                            AnswerModel(
                                text: text!, isCorrect: correctAnswer == 0));
                      },
                      label: "Resposta 1",
                      showError: true,
                      value: question.answers.isEmpty
                          ? ""
                          : question.answers[0].text,
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
                        question.answers.insert(
                            1,
                            AnswerModel(
                                text: text!, isCorrect: correctAnswer == 1));
                      },
                      label: "Resposta 2",
                      showError: true,
                      value: question.answers.isEmpty
                          ? ""
                          : question.answers[1].text,
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
                      question.answers.insert(
                          2,
                          AnswerModel(
                              text: text!, isCorrect: correctAnswer == 2));
                    },
                    label: "Resposta 3",
                    showError: false,
                    value: question.answers.isEmpty
                        ? ""
                        : question.answers[2].text,
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
                    onSaved: (text) {
                      question.answers.insert(
                          3,
                          AnswerModel(
                              text: text!, isCorrect: correctAnswer == 3));
                    },
                    label: "Resposta 4",
                    showError: false,
                    value: question.answers.isEmpty
                        ? ""
                        : question.answers[3].text,
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
                child: const Text("Editar"),
                onPressed: question.complete ? submit : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
