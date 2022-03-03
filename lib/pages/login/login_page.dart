import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:montanhas_quiz/pages/home/home_page.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';
import 'package:montanhas_quiz/pages/register/register_page.dart';
import 'package:montanhas_quiz/utils/message_snackbar.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Image.asset("assets/montanhas.png"),
            ),
            Center(
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Email:",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: TextField(
                      controller: senhaController,
                      obscureText: true,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Senha:",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (emailController.text.isNotEmpty &&
                            senhaController.text.isNotEmpty) {
                          if (await AuthProvider().login(
                            email: emailController.text,
                            password: senhaController.text,
                          )) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  user: AuthProvider().user,
                                ),
                              ),
                            );
                          } else {
                            MessageSnackBar(
                              context: context,
                              message: "O email ou a senha estão incorretos",
                            ).showMessage();
                          }
                        } else {
                          MessageSnackBar(
                            context: context,
                            message: "Preencha o email e a senha",
                          ).showMessage();
                        }
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
                                  builder: (context) => RegisterPage(),
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
    );
  }
}
