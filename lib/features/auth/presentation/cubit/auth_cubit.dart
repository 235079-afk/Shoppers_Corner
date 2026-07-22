import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final SignUpUseCase _signUpUseCase;

  AuthCubit(this._loginUseCase, this._signUpUseCase)
      : super(const AuthInitial());

  Future<void> login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      emit(const AuthError('Please fill in all fields'));
      return;
    }

    emit(const AuthLoading());

    try {
      final user = await _loginUseCase(username, password);
      emit(AuthSuccess(user.name));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      emit(const AuthError('Please fill in all fields'));
      return;
    }

    emit(const AuthLoading());

    try {
      final user = await _signUpUseCase(name, email, password);
      emit(AuthSuccess(user.name));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void logout() {
    emit(const AuthInitial());
  }
}
