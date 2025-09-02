import 'package:bloc/bloc.dart';
import 'package:blog/core/usecase/usecase.dart';
import 'package:blog/features/auth/domain/usecases/current_user.dart';
import 'package:blog/features/auth/domain/usecases/user_sign_up.dart';
import 'package:meta/meta.dart';
import '../../../../core/common/cubit/app_user/auth_user_cubit.dart';
import '../../../../core/entities/user.dart';
import '../../../../init_dependencies.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/user_login.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AuthUserCubit _authUserCubit;
  final Logout _logout;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required CurrentUser currentUser,
    required AuthUserCubit authUserCubit,
    required Logout logout,
  }) : _userSignUp = userSignUp,
       _userLogin = userLogin,
       _currentUser = currentUser,
        _logout = logout,
  _authUserCubit = authUserCubit,
       super(AuthInitial()) {
    on<AuthEvent>((_,emit) => emit(AuthLoading()));
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);
    on<AuthLogout>(_onAuthLogout);
  }

  void _onAuthLogout(AuthLogout event,Emitter<AuthState> emit)async{
    emit(AuthLoading());
    final res = await _logout(NoParams());
    res.fold(
          (failure) => emit(AuthFailure(failure.message)),
          (_) {
        _authUserCubit.logout();
        emit(AuthLoggedOut());
      },
    );
  }

  //for sign UP
  void _onAuthSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    //here i will use the usecase
    final res = await _userSignUp(
      UserSignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) =>  _emitAuthSuccess(user,emit),
    );
  }

  //for Current User that is Login or Not
  void _isUserLoggedIn(AuthIsUserLoggedIn event, Emitter<AuthState> emit,) async {
    //here i will use the usecase
    final res = await _currentUser(NoParams());

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),

      (user) =>  _emitAuthSuccess(user,emit),

    );
  }

  //for checking current session
  void _emitAuthSuccess(User user,Emitter<AuthState> emit)async{
    _authUserCubit.updateUser(user);
    emit(AuthSuccess(user));
  }


// for Login purpose
  void _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    //here i will use the usecase
    final res = await _userLogin(
      UserLoginParams(
          email: event.email,
          password: event.password
      ),
    );

    res.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => _emitAuthSuccess(user,emit),
    );
  }

}
