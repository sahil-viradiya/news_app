// ignore_for_file: empty_catches, unused_local_variable, avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haveliapp/auth/auth_repo.dart';
import 'package:haveliapp/auth/auth_state.dart';
import 'package:haveliapp/models/user_model.dart';
import 'package:haveliapp/utils.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(Init());
  AuthRepo authrepo = AuthRepo();

  Future<void> loadUserDetails() async {
    try {
      var response = await authrepo.userDetailsApi();
      print(response);
      emit(Authenticated(User.fromJson(response.data)));
    } catch (e) {
      DioError error = e as DioError;
      print(error);
      print("hi");
      if (error.response != null) {
        if (error.response!.statusCode == 401 ||
            error.response!.statusCode == 403) {
          emit(UnAuthenticated());
          deletToken();
        } else {
          try {
            emit(Failed(error.response!.data));
          } catch (e) {
            emit(Failed(error.response!.data['details']));
          }
        }
      } else {
        if (error.type == DioErrorType.unknown) {
          print("ii");
          emit(Failed("Please check your internate"));
        } else {
          emit(Failed(error.message));
        }
      }
    }
    return;
  }
}
