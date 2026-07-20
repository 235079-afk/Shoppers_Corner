import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return User(_nameFromUsername(username));
  }

  @override
  Future<User> signUp(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return User(name);
  }

  String _nameFromUsername(String username) {
    final cleaned = username.startsWith('@') ? username.substring(1) : username;
    final prefix = cleaned.split('@').first;
    if (prefix.isEmpty) return 'there';
    return prefix[0].toUpperCase() + prefix.substring(1);
  }
}
