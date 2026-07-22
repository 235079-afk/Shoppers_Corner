import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String email, String password) async {
    try {
      return await repository.login(email, password);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }
}
