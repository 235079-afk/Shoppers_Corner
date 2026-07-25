import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<void> verifyOtp(String email, String otp);
}
