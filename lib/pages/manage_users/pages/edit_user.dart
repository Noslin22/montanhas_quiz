import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:montanhas_quiz/global/utils/message_snackbar.dart';
import 'package:montanhas_quiz/global/widgets/field.dart';
import 'package:montanhas_quiz/models/user_model.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';
import 'package:montanhas_quiz/server/database_provider.dart';

class EditUser extends StatefulWidget {
  const EditUser({Key? key}) : super(key: key);

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  final List<FocusNode> focusNodes = List.generate(3, (index) => FocusNode());
  final _formKey = GlobalKey<FormState>();
  UserModel user = UserModel.empty();
  late Future<List<UserModel>> users;
  bool obscure = true;

  @override
  void initState() {
    super.initState();
    users = DatabaseProvider().listUsers(AuthProvider().user!);
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
          .editUser(AuthProvider().user!, user)
          .then((value) {
        Navigator.pop(context);
        if (value) {
          _formKey.currentState!.reset();
          user = UserModel.empty();
          MessageSnackBar(
                  context: context, message: "Usuário editado com sucesso")
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
                      focusNode: focusNodes[0],
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          user = value!;
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
                        if (value == null || value == UserModel.empty()) {
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
                focus: focusNodes[1],
                type: TextInputType.emailAddress,
                value: user.email ?? "",
                action: TextInputAction.next,
                onSaved: (text) {
                  user = user.copyWith(email: text);
                },
                label: "Email",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Este campo é obrigatório";
                  }
                  return null;
                },
              ),
            ),
            Field(
              type: TextInputType.visiblePassword,
              focus: focusNodes[2],
              action: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Este campo é obrigatório";
                }
                return null;
              },
              onSaved: (text) {
                user = user.copyWith(password: text);
              },
              onComplete: () => submit(),
              obscure: obscure,
              value: user.password ?? "",
              label: "Senha",
              suffix: IconButton(
                onPressed: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
                icon: Icon(
                  obscure ? Icons.visibility_rounded : Icons.visibility_off,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Adolescente"),
                      Radio<bool>(
                        value: false,
                        groupValue: user.isAdm,
                        onChanged: (value) {
                          setState(() {
                            user = user.copyWith(isAdm: value);
                          });
                        },
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Professor"),
                      Radio<bool>(
                        value: true,
                        groupValue: user.isAdm,
                        onChanged: (value) {
                          setState(() {
                            user = user.copyWith(isAdm: value);
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                child: const Text("Editar"),
                onPressed: user.complete ? submit : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
