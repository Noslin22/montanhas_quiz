import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:montanhas_quiz/global/widgets/field.dart';
import 'package:montanhas_quiz/models/user_model.dart';
import 'package:montanhas_quiz/pages/home/home_page.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';
import 'package:montanhas_quiz/pages/register/register_page.dart';
import 'package:montanhas_quiz/global/message_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  UserModel user = UserModel();
  bool obscure = true;
  bool save = true;

  Future<void> submit(BuildContext ctx) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (await AuthProvider().login(
        email: user.email!,
        password: user.password!,
        save: save,
      )) {
        Navigator.of(ctx).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => const HomePage(),
          ),
        );
      } else {
        MessageSnackBar(
          context: ctx,
          message: "O email ou a senha estão incorretos",
        ).showMessage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        onComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
                        onSaved: (text) {
                          user = user.copyWith(email: text);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Este campo é obrigatório";
                          } else if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return "Email inválido";
                          }
                          return null;
                        },
                        action: TextInputAction.next,
                        label: "Email",
                        type: TextInputType.emailAddress,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Field(
                          type: TextInputType.visiblePassword,
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
                          obscure: obscure,
                          label: "Senha",
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Text("Deseja permanecer logado?"),
                            Checkbox(
                              value: save,
                              onChanged: (check) {
                                setState(() {
                                  save = check!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: () async {
                            await submit(context);
                          },
                          child: const Text("Entrar"),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Se não tiver uma conta ",
                          style: const TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: "clique aqui",
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const RegisterPage(),
                                    ),
                                  );
                                },
                            ),
                          ],
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
