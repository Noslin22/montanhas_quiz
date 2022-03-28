import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:montanhas_quiz/global/utils/message_snackbar.dart';
import 'package:montanhas_quiz/models/question_model.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';
import 'package:montanhas_quiz/server/database_provider.dart';

class DeleteQuestion extends StatefulWidget {
  final AuthProvider auth;
  final DatabaseProvider db;

  const DeleteQuestion({
    Key? key,
    required this.auth,
    required this.db,
  }) : super(key: key);

  @override
  State<DeleteQuestion> createState() => _DeleteQuestionState();
}

class _DeleteQuestionState extends State<DeleteQuestion> {
  late Future<List<QuestionModel>> questions;
  final _formKey = GlobalKey<FormState>();

  String? id;

  @override
  void initState() {
    questions = widget.db.listQuestions(widget.auth.user!);
    super.initState();
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
                          id = value!.id;
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
                        if (value == null) {
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
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                child: const Text("Deletar"),
                onPressed: id == null
                    ? null
                    : () {
                        widget.db
                            .deleteQuestion(widget.auth.user!, id!)
                            .then((value) {
                          questions =
                              widget.db.listQuestions(widget.auth.user!);
                          if (value) {
                            _formKey.currentState!.reset();
                            MessageSnackBar(
                                    context: context,
                                    message: "Pergunta deletada com sucesso")
                                .showMessage();
                          } else {
                            MessageSnackBar(
                              context: context,
                              message: "Ocorreu um problema, tente novamente",
                            ).showMessage();
                          }
                          setState(() {});
                        });
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
