import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:montanhas_quiz/global/utils/message_snackbar.dart';
import 'package:montanhas_quiz/models/question_model.dart';
import 'package:montanhas_quiz/models/user_model.dart';
import 'package:http/http.dart';
import 'package:montanhas_quiz/server/auth_provider.dart';

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
      headers: {
        'authorization': credencials
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      questions =
          jsonList.map((e) => QuestionModel.fromMap(e, user.nome!)).toList();
      questions.sort(
        (a, b) {
          return DateTime.parse(
                  b.subtitle!.split(" ")[1].split("/").reversed.join())
              .compareTo(
            DateTime.parse(
                a.subtitle!.split(" ")[1].split("/").reversed.join()),
          );
        },
      );
    }

    return response.statusCode == 200;
  }

  Future<List<QuestionModel>> listQuestions(UserModel user) async {
    String credencials = "Bearer ${user.token!}";

    Response response = await get(
      Uri.parse('https://db-montanhas.herokuapp.com/questions'),
      headers: {
        'authorization': credencials
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);

      final questionList =
          jsonList.map((e) => QuestionModel.fromMap(e, user.nome!)).toList();
      questionList.sort(
        (a, b) {
          return DateTime.parse(
                  b.subtitle!.split(" ")[1].split("/").reversed.join())
              .compareTo(
            DateTime.parse(
                a.subtitle!.split(" ")[1].split("/").reversed.join()),
          );
        },
      );
      return questionList;
    }
    return [];
  }

  Future<List<UserModel>> listUsers(UserModel user) async {
    String credencials = "Bearer ${user.token!}";

    Response response = await get(
      Uri.parse('https://db-montanhas.herokuapp.com/users'),
      headers: {
        'authorization': credencials
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList.map((e) {
        return UserModel.fromDatabase(e);
      }).toList();
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

  Future<bool> doneQuestion(UserModel user, QuestionModel question, bool correct) async {
    String credencials = "Bearer ${user.token!}";

    Request request = Request(
      "POST",
      Uri.parse('https://db-montanhas.herokuapp.com/questions/${question.id}/users'),
    );
    request.headers.addAll({
      'Authorization': credencials,
      'Content-Type': 'application/json',
    });
    request.body = jsonEncode({"user": user.nome, "correct": correct});

    StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      getQuestions(user);
    }
    return response.statusCode == 200;
  }

  Future<bool> addQuestion(
      UserModel user, Map<String, dynamic> question, BuildContext ctx) async {
    String credencials = "Bearer ${user.token!}";

    Request request = Request(
      "POST",
      Uri.parse('https://db-montanhas.herokuapp.com/questions'),
    );
    request.headers.addAll({
      'Authorization': credencials,
      'Content-Type': 'application/json',
    });
    request.body = jsonEncode(question);

    StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      getQuestions(user);
    } else if (response.statusCode == 403 && user.isAdm!) {
      await AuthProvider()
          .login(email: user.email!, password: user.password!)
          .then(
        (value) {
          MessageSnackBar(
            context: ctx,
            message: "Ocorreu um problema, tente novamente",
          ).showMessage();
        },
      );
    }
    return response.statusCode == 200;
  }

  Future<bool> editQuestion(UserModel user, QuestionModel question) async {
    String credencials = "Bearer ${user.token!}";

    Request request = Request(
      "PUT",
      Uri.parse('https://db-montanhas.herokuapp.com/questions/${question.id}'),
    );
    request.headers.addAll({
      'Authorization': credencials,
      'Content-Type': 'application/json',
    });
    request.body = question.toJson();

    StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      getQuestions(user);
    }
    return response.statusCode == 200;
  }

  Future<bool> deleteQuestion(UserModel user, String id) async {
    String credencials = "Bearer ${user.token!}";

    Request request = Request(
      "DELETE",
      Uri.parse('https://db-montanhas.herokuapp.com/questions/$id'),
    );
    request.headers.addAll({
      'Authorization': credencials,
      'Content-Type': 'application/json',
    });

    StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      getQuestions(user);
    }
    return response.statusCode == 200;
  }

  Future<bool> cleanQuestions(UserModel user) async {
    String credencials = "Bearer ${user.token!}";

    Request request = Request(
      "DELETE",
      Uri.parse('https://db-montanhas.herokuapp.com/questions'),
    );
    request.headers.addAll({
      'Authorization': credencials,
      'Content-Type': 'application/json',
    });

    StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      getQuestions(user);
    }

    List<UserModel> users = await listUsers(user);
    for (var userModel in users) {
      userModel = userModel.copyWith(percent: 0);
      if (userModel.id == AuthProvider().user!.id) {
        AuthProvider().user = userModel;
      }
      Request request = Request(
        "PUT",
        Uri.parse('https://db-montanhas.herokuapp.com/users/${userModel.id}'),
      );
      request.headers.addAll({
        'Authorization': credencials,
        'Content-Type': 'application/json',
      });
      request.body = userModel.toJson();
      await request.send();
    }

    if (response.statusCode == 200) {
      getQuestions(user);
    }
    return response.statusCode == 200;
  }
}
