import 'package:flutter/material.dart';
import 'package:montanhas_quiz/global/widgets/drawer/adm_drawer.dart';
import 'package:montanhas_quiz/global/widgets/drawer/screens.dart';
import 'package:montanhas_quiz/pages/manage_questions/pages/add_question.dart';
import 'package:montanhas_quiz/pages/manage_questions/pages/delete_question.dart';
import 'package:montanhas_quiz/pages/manage_questions/pages/edit_question.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';
import 'package:montanhas_quiz/server/database_provider.dart';

import 'pages/delete_user.dart';
import 'pages/edit_user.dart';

class ManageUsers extends StatefulWidget {
  const ManageUsers({Key? key}) : super(key: key);

  @override
  State<ManageUsers> createState() => _ManageUsersState();
}

class _ManageUsersState extends State<ManageUsers> {
  final AuthProvider auth = AuthProvider();
  final DatabaseProvider db = DatabaseProvider();
  final List<BottomNavigationBarItem> items = [
    const BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Editar"),
    const BottomNavigationBarItem(icon: Icon(Icons.delete), label: "Deletar"),
  ];

  late final Map<String, Widget> pages;

  int page = 0;

  @override
  void initState() {
    pages = {
      "Editar": const EditUser(),
      "Deletar": DeleteUser(auth: auth, db: db),
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdmDrawer(
        screen: Screens.questions,
      ),
      appBar: AppBar(
        title: Text("${pages.keys.toList()[page]} Usuário"),
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
