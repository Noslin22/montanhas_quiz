import 'dart:convert';

import 'package:montanhas_quiz/models/question_model.dart';
import 'package:montanhas_quiz/models/user_model.dart';
import 'package:http/http.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();

  factory DatabaseProvider() => _instance;

  DatabaseProvider._internal();

  Future<List<QuestionModel>> getQuestions(UserModel user) async {
    String credencials = "Bearer ${user.token!}";

    Response response = await get(
      Uri.parse('https://db-montanhas.herokuapp.com/questions'),
      headers: {'authorization': credencials},
    );
    if (response.statusCode == 200) {
      List<dynamic> questions = jsonDecode(response.body);

      return questions.map((e) => QuestionModel.fromMap(e, user.nome)).toList();
    }
    return [];
  }

  Future<bool> rightQuestion(UserModel user) async {
    String credencials = "Bearer ${user.token!}";

    Request request = Request(
      "PUT",
      Uri.parse('https://db-montanhas.herokuapp.com/users/${user.id}'),
    );
    request.headers.addAll({
      'Authorization': credencials,
      'Content-Type': 'application/json',
    });
    request.body = user.toJson();

    StreamedResponse response = await request.send();
    return response.statusCode == 200;
  }

  Future<bool> doneQuestion(UserModel user, QuestionModel question) async {
    String credencials = "Bearer ${user.token!}";

    Request request = Request(
      "PUT",
      Uri.parse('https://db-montanhas.herokuapp.com/questions/${question.id}'),
    );
    request.headers.addAll({
      'Authorization': credencials,
      'Content-Type': 'application/json',
    });
    request.body = user.toJson();

    StreamedResponse response = await request.send();
    return response.statusCode == 200;
  }
}
