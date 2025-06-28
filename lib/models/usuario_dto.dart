// To parse this JSON data, do
//
//     final usuarioDto = usuarioDtoFromJson(jsonString);

import 'dart:convert';

UsuarioDto usuarioDtoFromJson(String str) =>
    UsuarioDto.fromJson(json.decode(str));

String usuarioDtoToJson(UsuarioDto data) => json.encode(data.toJson());

class UsuarioDto {
  final int? id;
  final String? email;
  final String? password;
  final bool? estado;
  final DateTime? createdAt;

  UsuarioDto({this.id, this.email, this.password, this.estado, this.createdAt});

  factory UsuarioDto.fromJson(Map<String, dynamic> json) => UsuarioDto(
    id: json["id"],
    email: json["email"],
    password: json["password"],
    estado: json["estado"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "password": password,
    "estado": estado,
    "createdAt": createdAt!.toIso8601String(),
  };

  Map<String, dynamic> toJsonPost() => {"email": email, "password": password};
}
