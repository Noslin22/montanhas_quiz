import 'dart:convert';

import 'package:flutter/cupertino.dart';

class UserModel {
  String nome;
  String email;
  String id;
  String password;
  bool isAdm;

  final ValueNotifier<double> percentNotifier;
  double get percent => percentNotifier.value;
  set percent(double value) => percentNotifier.value = value;

  String? token;

  UserModel({
    this.isAdm = false,
    required this.nome,
    required this.email,
    required this.password,
    required this.id,
    required double percent,
    this.token,
  }) : percentNotifier = ValueNotifier(percent);

  Map<String, dynamic> toMap() {
    return {
      'name': nome,
      'email': email,
      'id': id,
      'token': token,
      'password': password,
      'percent': percent,
      'isAdm': isAdm
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      nome: map["user"]['name'] ?? '',
      password: map["user"]['password'] ?? '',
      percent: map["user"]['percent'] ?? 0,
      email: map["user"]['email'] ?? '',
      id: map["user"]['id'] ?? '',
      isAdm: map["user"]['isAdm'] ?? false,
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'UserModel(nome: $nome, email: $email, id: $id, token: $token, percent: $percent)';

  UserModel copyWith({
    String? nome,
    String? email,
    String? password,
    double? percent,
    String? id,
    String? token,
    bool? isAdm,
  }) {
    return UserModel(
      nome: nome ?? this.nome,
      percent: percent ?? this.percent,
      password: password ?? this.password,
      email: email ?? this.email,
      id: id ?? this.id,
      token: token ?? this.token, isAdm: isAdm ?? this.isAdm,
    );
  }
}
