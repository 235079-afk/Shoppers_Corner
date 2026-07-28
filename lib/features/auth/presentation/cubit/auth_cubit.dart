import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/local_keys.dart';
import '../../../../core/local_storage/base_local_storage.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final BaseLocalStorage _localStorage;

  AuthCubit(
    this._loginUseCase,
    this._signUpUseCase,
    this._verifyOtpUseCase,
    this._localStorage,
  ) : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      emit(const AuthError('Please fill in all fields'));
      return;
    }

    emit(const AuthLoading());

    final result = await _loginUseCase(email, password);

    await result.fold(
      (failure) async => emit(AuthError(failure.message)),
      (user) async {
        if (kDebugMode) {
          log('Login token received, length: ${user.accessToken.length}');
        }
        await _localStorage.setString(LocalKeys.accessToken, user.accessToken);
        emit(AuthSuccess(user));
      },
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

  Future<void> logout() async {
    await _localStorage.clear();
    emit(const AuthInitial());
  }
}
