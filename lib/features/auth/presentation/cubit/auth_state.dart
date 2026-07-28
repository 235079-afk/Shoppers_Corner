import 'package:flutter_app/features/auth/domain/entities/user.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final AuthResponse user;
  const AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

class AuthOtpRequired extends AuthState {
  final String email;
  const AuthOtpRequired(this.email);
}

class AuthOtpVerified extends AuthState {
  const AuthOtpVerified();
}
