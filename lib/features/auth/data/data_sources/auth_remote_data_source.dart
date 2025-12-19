import 'package:blog_app/core/error/exeptions.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String emial,
    required String password,
  });
  Future<UserModel> loginWithEmailPassword({
    required String emial,
    required String password,
  });
  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String emial,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: emial,
        data: {'name': name},
      );
      if (response.user == null) {
        throw const ServerExeption('User is null !!');
      }
      return UserModel.fromjson(response.user!.toJson());
    } catch (e) {
      throw ServerExeption(e.toString());
    }
  }

  @override
  Future<UserModel> loginWithEmailPassword({
    required String emial,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: emial,
      );
      if (response.user == null) {
        throw const ServerExeption('User is null !!');
      }
      return UserModel.fromjson(response.user!.toJson());
    } catch (e) {
      throw ServerExeption(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);
        return UserModel.fromjson(
          userData.first,
        ).copyWith(email: currentUserSession!.user.email);
      }
      return null;
    } catch (e) {
      throw ServerExeption(e.toString());
    }
  }
}
