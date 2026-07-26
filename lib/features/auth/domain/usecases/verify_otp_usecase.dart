import 'package:flutter_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, Unit>> call(String email, String otp) {
    return repository.verifyOtp(email, otp);
  }
}
