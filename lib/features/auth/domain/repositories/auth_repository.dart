import 'package:flutter_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);

  Future<Either<Failure, Unit>> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> verifyOtp(String email, String otp);
}
