import 'package:bloc/bloc.dart';
import 'package:blog/features/auth/domain/entities/user.dart';
import 'package:blog/features/auth/domain/usecases/user_sign_up.dart';
import 'package:meta/meta.dart';

import '../../domain/usecases/user_login.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final UserSignUp _userSignUp;
  final UserLogin _userLogin;


  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin
  }) : _userSignUp = userSignUp,
      _userLogin = userLogin,
      super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
  }

  void _onAuthSignUp(AuthSignUp event,Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }


  void _onAuthLogin(AuthLogin event,Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final res = await _userLogin(
        UserLoginParams(
        email: event.email,
        password: event.password
    ));

    res.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (user) => emit(AuthSuccess(user)),
    );
  }

}
