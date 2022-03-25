import 'package:flutter/material.dart';
import 'package:montanhas_quiz/global/widgets/field.dart';
import 'package:montanhas_quiz/models/user_model.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';
import 'package:montanhas_quiz/global/message_snackbar.dart';

import '../home/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  UserModel user = UserModel();

  bool obscure = true;

  Future<void> submit(BuildContext ctx) async {
    if (_formKey.currentState!.validate()) {
      if (await AuthProvider().register(
        email: user.email!,
        password: user.password!,
        name: user.nome!,
      )) {
        Navigator.of(ctx).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (ctx) => const HomePage(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        MessageSnackBar(
          context: ctx,
          message: "Houve um erro ao registrar, tente novamente mais tarde",
        ).showMessage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Hero(
                    tag: "montanhas",
                    child: Image.asset("assets/montanhas.png"),
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      Field(
                        type: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Este campo é obrigatório";
                          } else if (value.length < 3) {
                            return "O nome necessita de pelo menos 3 letras";
                          }
                          return null;
                        },
                        label: "Nome",
                        action: TextInputAction.next,
                        onComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        onSaved: (text) {
                          user = user.copyWith(nome: text);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Field(
                          type: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Este campo é obrigatório";
                            }
                            return null;
                          },
                          label: "Email",
                          action: TextInputAction.next,
                          onComplete: () {
                            FocusScope.of(context).nextFocus();
                          },
                          onSaved: (text) {
                            user = user.copyWith(password: text);
                          },
                        ),
                      ),
                      Field(
                        type: TextInputType.visiblePassword,
                        action: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Este campo é obrigatório";
                          } else if (value.length < 6) {
                            return "A senha precisa te no minimo 6 caracteres";
                          }
                          return null;
                        },
                        obscure: obscure,
                        label: "Senha",
                        onSaved: (text) {
                          user = user.copyWith(password: text);
                        },
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                          icon: Icon(
                            obscure
                                ? Icons.visibility_rounded
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: ElevatedButton(
                          onPressed: () async {
                            submit(context);
                          },
                          child: const Text("Registrar"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
