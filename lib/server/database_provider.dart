import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:montanhas_quiz/models/question_model.dart';
import 'package:montanhas_quiz/models/user_model.dart';
import 'package:http/http.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();

  final ValueNotifier<List<QuestionModel>> questionsNotifier =
      ValueNotifier([]);
  List<QuestionModel> get questions => questionsNotifier.value;
  set questions(List<QuestionModel> questions) =>
      questionsNotifier.value = questions;

  factory DatabaseProvider() => _instance;

  DatabaseProvider._internal();

  Future<bool> getQuestions(UserModel user) async {
    String credencials = "Bearer ${user.token!}";

    Response response = await get(
      Uri.parse('https://db-montanhas.herokuapp.com/questions'),
      headers: {'authorization': credencials},
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);

      questions =
          jsonList.map((e) => QuestionModel.fromMap(e, user.nome)).toList();
    }
    return response.statusCode == 200;
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
      "POST",
      Uri.parse(
          'https://db-montanhas.herokuapp.com/questions/${question.id}/users'),
    );
    request.headers.addAll({
      'Authorization': credencials,
      'Content-Type': 'application/json',
    });
    request.body = jsonEncode({"user": user.nome});

    StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      getQuestions(user);
    }
    return response.statusCode == 200;
  }
}
