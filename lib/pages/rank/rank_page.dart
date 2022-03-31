import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:montanhas_quiz/global/widgets/drawer/adm_drawer.dart';
import 'package:montanhas_quiz/global/widgets/drawer/screens.dart';
import 'package:montanhas_quiz/pages/rank/widgets/rank_pdf.dart';
import 'package:montanhas_quiz/pages/rank/widgets/rank_tile.dart';
import 'package:montanhas_quiz/server/database_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../global/utils/loading_dialog.dart';
import '../../models/question_model.dart';
import '../../models/user_model.dart';

class RankPage extends StatefulWidget {
  const RankPage({
    Key? key,
    required this.user,
  }) : super(key: key);
  final UserModel user;

  @override
  State<RankPage> createState() => _RankPageState();
}

class _RankPageState extends State<RankPage> {
  late Future<List<UserModel>> users;
  late List<QuestionModel> questions;

  final DatabaseProvider db = DatabaseProvider();
  @override
  void initState() {
    users = db.listUsers(widget.user);
    questions = db.questions;
    questions.sort(
      (a, b) {
        return DateTime.parse(
                a.subtitle!.split(" ")[1].split("/").reversed.join())
            .compareTo(
          DateTime.parse(b.subtitle!.split(" ")[1].split("/").reversed.join()),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rank Geral"),
      ),
      drawer: const AdmDrawer(screen: Screens.rank),
      body: FutureBuilder<List<UserModel>>(
        future: users,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserModel> users =
                snapshot.data!.where((element) => !element.isAdm!).toList();
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      UserModel user = users[index];
                      return RankTile(name: user.nome!, percent: user.percent!);
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    LoadingDialog.showLoading(context);
                    Uint8List bytes = await RankPdf.buildPdf(
                      questions: questions,
                      users: users,
                    );
                    Navigator.pop(context);
                    String date = DateFormat("dd/MM/y").format(DateTime.now());
                    await Printing.layoutPdf(
                      onLayout: (PdfPageFormat format) => bytes,
                      name: "Gabarito - $date.pdf",
                    );
                  },
                  child: Container(
                    width: double.maxFinite,
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          "${users.length} Adolescentes responderam",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
