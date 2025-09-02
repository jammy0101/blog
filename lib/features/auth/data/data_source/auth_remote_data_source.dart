import 'package:blog/core/error/exceptions.dart';
import 'package:blog/features/auth/data/models/user_model.dart';
import 'package:blog/features/blog/data/model/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// AuthRemoteDataSource (data source)
// Knows how to talk to Supabase.
// Responsible only for making API calls.
// Example: supabase.auth.signUp(...).
abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel?> getCurrentUserData();
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<void> logout();
}



// An interface defines a contract (what methods must exist)
// but does not provide the actual implementation.
// Classes that implement the interface provide the real logic.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  // Its is for the current session
  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);
        return UserModel.fromJson(userData.first);
      }
      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );

      if (response.user == null) {
        throw ServerException('User is null!');
      }

      return UserModel.fromJson(response.user!.toJson());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  //for to do this you will do--> auth_repository_impl
  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name},
      );
      if (response.user == null) {
        throw ServerException('User is null');
      }
      return UserModel.fromJson(
        response.user!.toJson(),
      ).copyWith(email: currentUserSession!.user.email);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout()async{
    try{
      await supabaseClient.auth.signOut();
    }catch(e){
      throw ServerException(e.toString());
    }
  }
}
