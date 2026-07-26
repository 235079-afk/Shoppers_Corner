import 'package:flutter_app/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    return await repository.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
  }
}

