import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../../../models/question_model.dart';
import '../../../models/user_model.dart';
import '../../../global/extensions/percent.dart';

class RankPdf {
  static Future<Uint8List> buildPdf({
    required List<QuestionModel> questions,
    required List<UserModel> users,
  }) async {
    final ByteData montanhasImage =
        await rootBundle.load('assets/montanhas.png');
    Document doc = Document();

    doc.addPage(Page(
      pageFormat: PdfPageFormat.a4,
      build: (Context context) {
        return Stack(children: [
          Center(
            child: Opacity(
              opacity: 0.1,
              child: Image(
                MemoryImage(
                  montanhasImage.buffer.asUint8List(),
                ),
                width: 300,
                height: 300,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "IASD Central FSA - Adolescentes (Base Montanhas)",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 12),
              Text(
                "Boletim Semanal - ${questions.first.subtitle!.split(" ")[1].substring(0, 5)} a ${questions.last.subtitle!.split(" ")[1].substring(0, 5)}",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 12),
              Divider(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    Text(
                      "Gabarito:",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      direction: Axis.vertical,
                      spacing: 2,
                      children: [
                        for (var i = 0; i < questions.length; i++)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Text("${i + 1}. "),
                                  Text(
                                    "${questions[i].question!.substring(0, questions[i].question!.length > 63 ? 63 : questions[i].question!.length)}${questions[i].question!.length > 63 ? "..." : ""}",
                                  ),
                                ],
                              ),
                              Text(
                                "Resposta: ${questions[i].answers.firstWhere((element) => element.isCorrect).text}",
                              ),
                            ],
                          )
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 12),
                    Text(
                      "Rank Semanal",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Participantes: ",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (_, index) {
                          UserModel user = users[index];
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Text(
                                  "${user.nome} - ${user.percent!.percent()}",
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ]); // Center
      },
    ));
    return doc.save();
  }
}
