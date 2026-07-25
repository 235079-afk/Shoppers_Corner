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
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }

  @override
  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "confirmPassword": password,
        "firstName": firstName,
        "lastName": lastName,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Registration failed: ${response.body}");
    }
  }

  @override
  Future<void> verifyOtp(String email, String otp) async {
    final url = Uri.parse("$baseUrl/verify-email");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "otp": otp}),
    );

    if (response.statusCode != 200) {
      throw Exception("Invalid OTP. Please try again.");
    }
  }
}
