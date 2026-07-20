abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final String name;
  const AuthSuccess(this.name);
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
