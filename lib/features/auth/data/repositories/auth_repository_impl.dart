import 'dart:convert';
import 'package:flutter_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final String baseUrl = "https://accessories-eshop.runasp.net/api/auth";

  @override
  Future<Either<Failure, AuthResponse>> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final user = AuthResponse.fromJson(jsonDecode(response.body));
        return right(user);
      } else {
        return left(ServerFailure("Login failed: ${response.body}"));
      }
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/register");

    try {
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

      if (response.statusCode == 200) {
        return right(unit);
      } else {
      return left(ServerFailure("Registration failed: ${response.body}"));
      }
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
Future<Either<Failure, Unit>> verifyOtp(String email, String otp) async {
  final url = Uri.parse("$baseUrl/verify-email");

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "otp": otp,  
      }),
    );

    if (response.statusCode == 200) {
      return right(unit);
    } else {
      return left(ServerFailure("OTP verification failed: ${response.body}"));
    }
  } catch (e) {
    return left(ServerFailure(e.toString()));
  }
}


}
