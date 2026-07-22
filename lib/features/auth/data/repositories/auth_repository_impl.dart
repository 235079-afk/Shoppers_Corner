import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final String baseUrl = "https://accessories-eshop.runasp.net/api/auth";

  @override
  Future<User> login(String email, String password) async {

    final url = Uri.parse("$baseUrl/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UserModel.fromJson(json);
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  @override
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
      return UserModel.fromJson(json);
    } else {
      throw Exception("Signup failed: ${response.body}");
    }
  }
}
