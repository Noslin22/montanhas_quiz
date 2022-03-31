import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:montanhas_quiz/global/utils/message_snackbar.dart';
import 'package:montanhas_quiz/models/question_model.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';
import 'package:montanhas_quiz/server/database_provider.dart';

import '../../../models/user_model.dart';

class DeleteUser extends StatefulWidget {
  final AuthProvider auth;
  final DatabaseProvider db;

  const DeleteUser({
    Key? key,
    required this.auth,
    required this.db,
  }) : super(key: key);

  @override
  State<DeleteUser> createState() => _DeleteUserState();
}

class _DeleteUserState extends State<DeleteUser> {
  late Future<List<UserModel>> users;
  final _formKey = GlobalKey<FormState>();

  String? id;

  @override
  void initState() {
    users = widget.db.listUsers(widget.auth.user!);
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
            FutureBuilder<List<UserModel>>(
                future: users,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    snapshot.data!.removeWhere(
                      (element) => element.nome == AuthProvider().user!.nome,
                    );
                    return DropdownButtonFormField<UserModel>(
                      items: snapshot.data!
                          .map((e) => DropdownMenuItem(
                                child: Text(
                                  e.nome!,
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
                        labelText: "Usuário",
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
                          return "Escolha um usuário";
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
                            .deleteUser(widget.auth.user!, id!)
                            .then((value) {
                          users = widget.db.listUsers(widget.auth.user!);
                          if (value) {
                            _formKey.currentState!.reset();
                            MessageSnackBar(
                                    context: context,
                                    message: "Usuário deletado com sucesso")
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
