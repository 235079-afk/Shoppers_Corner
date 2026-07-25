import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<void> call(String email, String otp) {
    return repository.verifyOtp(email, otp);
  }
}
