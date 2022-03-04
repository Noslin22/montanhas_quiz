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

  final FocusNode nomeFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode senhaFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  Future<void> submit(BuildContext ctx) async {
    if (_formKey.currentState!.validate()) {
      if (await AuthProvider().register(
        email: emailController.text,
        password: senhaController.text,
        name: nomeController.text,
      )) {
        Navigator.of(ctx).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (ctx) => HomePage(
              user: AuthProvider().user,
            ),
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
                      TextFormField(
                        focusNode: nomeFocus,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.name,
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
                        child: TextFormField(
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
                      ),
                      TextFormField(
                        focusNode: senhaFocus,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Este campo é obrigatório";
                          }
                          return null;
                        },
                        onEditingComplete: () async {
                          await submit(context);
                        },
                        controller: senhaController,
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
