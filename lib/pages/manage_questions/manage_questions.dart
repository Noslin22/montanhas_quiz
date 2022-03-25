import 'package:flutter/material.dart';
import 'package:montanhas_quiz/global/widgets/drawer/adm_drawer.dart';
import 'package:montanhas_quiz/global/widgets/drawer/screens.dart';
import 'package:montanhas_quiz/pages/manage_questions/pages/add_question.dart';
import 'package:montanhas_quiz/pages/manage_questions/pages/delete_question.dart';
import 'package:montanhas_quiz/pages/manage_questions/pages/edit_question.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';
import 'package:montanhas_quiz/server/database_provider.dart';

class ManageQuestions extends StatefulWidget {
  const ManageQuestions({Key? key}) : super(key: key);

  @override
  State<ManageQuestions> createState() => _ManageQuestionsState();
}

class _ManageQuestionsState extends State<ManageQuestions> {
  final AuthProvider auth = AuthProvider();
  final DatabaseProvider db = DatabaseProvider();
  final List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(icon: Icon(Icons.add), label: "Adicionar"),
    const BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Editar"),
    const BottomNavigationBarItem(icon: Icon(Icons.delete), label: "Deletar"),
  ];

  late final Map<String, Widget> pages;

  int page = 0;

  @override
  void initState() {
    pages = {
      "Adicionar": const AddQuestion(),
      "Editar": const EditQuestion(),
      "Deletar": DeleteQuestion(auth: auth, db: db),
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdmDrawer(
        screen: Screens.manage,
      ),
      appBar: AppBar(
        title: Text("${pages.keys.toList()[page]} Perguntas"),
      ),
      body: pages.values.toList()[page],
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        currentIndex: page,
        onTap: (index) {
          setState(() {
            page = index;
          });
        },
      ),
    );
  }
}
