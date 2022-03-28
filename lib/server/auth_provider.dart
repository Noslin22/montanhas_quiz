import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:montanhas_quiz/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {
  static final AuthProvider _instance = AuthProvider._internal();

  factory AuthProvider() => _instance;

  AuthProvider._internal();

  static final ValueNotifier<UserModel?> userNotifier = ValueNotifier(null);

  UserModel? get user => userNotifier.value;
  set user(UserModel? user) => userNotifier.value = user;

  Future<bool> login(
      {required String email,
      required String password,
      bool save = true}) async {
    String info = "$email:$password";
    String encode = base64Encode(info.codeUnits);
    if (save) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('user', [email, password]);
    }

    String credencials = "Basic $encode";

    Response response = await get(
      Uri.parse('https://db-montanhas.herokuapp.com/auth'),
      headers: {
        'authorization': credencials,
      },
    );
    if (response.statusCode == 200) {
      user = UserModel.fromJson(response.body).copyWith(password: password);
    }
    return response.statusCode == 200;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    Request request = Request(
      "POST",
      Uri.parse('https://db-montanhas.herokuapp.com/users'),
    );
    request.headers.addAll({
      'Content-Type': 'application/json',
    });
    request.body = jsonEncode({
      "name": name,
      "email": email,
      "isAdm": false,
      "password": password,
      "percent": 0.00,
    });

    StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      await login(email: email, password: password);
    }
    return response.statusCode == 200;
  }
}
