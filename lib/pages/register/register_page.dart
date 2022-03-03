import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';
import 'package:montanhas_quiz/utils/message_snackbar.dart';

import '../home/home_page.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
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
                    controller: nomeController,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Nome:",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: TextField(
                      controller: emailController,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Email:",
                      ),
                    ),
                  ),
                  TextField(
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
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (nomeController.text.isNotEmpty &&
                            emailController.text.isNotEmpty &&
                            senhaController.text.isNotEmpty) {
                          if (await AuthProvider().register(
                            email: emailController.text,
                            password: senhaController.text,
                            name: nomeController.text,
                          )) {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => HomePage(
                                  user: AuthProvider().user,
                                ),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          } else {
                            MessageSnackBar(
                              context: context,
                              message: "Houve um erro ao registrar, tente novamente mais tarde",
                            ).showMessage();
                          }
                        } else {
                          MessageSnackBar(
                            context: context,
                            message: "Preencha o nome, o email e a senha",
                          ).showMessage();
                        }
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
    );
  }
}
