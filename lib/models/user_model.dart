import 'dart:convert';

class UserModel {
  final String? nome;
  final String? email;
  final String? id;
  final String? password;
  final bool? isAdm;
  final double? percent;
  String? token;

  UserModel({
    this.isAdm = false,
    this.nome,
    this.email,
    this.password,
    this.id,
    this.percent,
    this.token,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': nome,
      'email': email,
      'id': id,
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

  factory UserModel.fromDatabase(Map<String, dynamic> map) {
    return UserModel(
      nome: map['name'] ?? '',
      password: map['password'] ?? '',
      percent: map['percent'] ?? 0,
      email: map['email'] ?? '',
      id: map['id'] ?? '',
      isAdm: map['isAdm'] ?? false,
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
      token: token ?? this.token,
      isAdm: isAdm ?? this.isAdm,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.nome == nome &&
        other.email == email &&
        other.id == id &&
        other.password == password &&
        other.isAdm == isAdm &&
        other.percent == percent &&
        other.token == token;
  }

  @override
  int get hashCode {
    return nome.hashCode ^
        email.hashCode ^
        id.hashCode ^
        password.hashCode ^
        isAdm.hashCode ^
        percent.hashCode ^
        token.hashCode;
  }
}
