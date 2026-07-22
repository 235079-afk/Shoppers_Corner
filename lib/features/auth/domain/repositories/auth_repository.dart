import 'dart:convert';
import 'package:http/http.dart' as http;
import '../entities/user.dart';

class AuthRepository {
  final String baseUrl = "https://accessories-eshop.runasp.net/api/auth";

  Future<User> login(String email, String password) async {
  final url = Uri.parse("$baseUrl/login");

  final response = await http.post(
    url,
    headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    },
    body: jsonEncode({
      "email": email,
      "password": password,
    }),
  );

  final json = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return User(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      token: json["token"] ?? "",
    );
  } else {
    // Extract validation errors
    if (json["errors"] != null) {
      final errors = json["errors"] as Map<String, dynamic>;
      final messages = errors.values
          .expand((list) => List<String>.from(list))
          .join("\n");

      throw Exception(messages);
    }

    throw Exception(json["message"] ?? "Login failed");
  }
}


  Future<User> signUp(String name, String email, String password) async {
    final url = Uri.parse("$baseUrl/signup");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      return User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        token: json["token"],
      );
    } else {
      throw Exception("Signup failed: ${response.body}");
    }
  }
}
