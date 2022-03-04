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

  final FocusNode emailFocus = FocusNode();
  final FocusNode senhaFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  Future<void> submit(BuildContext ctx) async {
    if (_formKey.currentState!.validate()) {
      if (await AuthProvider().login(
        email: emailController.text,
        password: senhaController.text,
      )) {
        Navigator.of(ctx).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => HomePage(
              user: AuthProvider().user,
            ),
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
                      TextFormField(
                        focusNode: emailFocus,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Este campo é obrigatório";
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () {
                          FocusScope.of(context).nextFocus();
                        },
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
                        child: TextFormField(
                          focusNode: senhaFocus,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          controller: senhaController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Este campo é obrigatório";
                            }
                            return null;
                          },
                          onEditingComplete: () async {
                            await submit(context);
                          },
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
        ),
      ),
    );
  }
}
