import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;

  AuthCubit(this._loginUseCase, this._signUpUseCase, this._verifyOtpUseCase)
      : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(const AuthError('Please fill in all fields'));
      return;
    }

    emit(const AuthLoading());

    final result = await _loginUseCase(email, password);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user.name)),
    );
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      emit(const AuthError('Please fill in all fields'));
      return;
    }

    emit(const AuthLoading());

    final result = await _signUpUseCase(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthOtpRequired(email)),
    );
  }

  Future<void> verifyOtp(String email, String otp) async {
    emit(const AuthLoading());

    final result = await _verifyOtpUseCase(email, otp);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const AuthOtpVerified()),
    );
  }

  void logout() {
    emit(const AuthInitial());
  }
}
