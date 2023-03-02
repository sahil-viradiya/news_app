import 'package:haveliapp/models/user_model.dart';

abstract class AuthState {}

class Init extends AuthState {}

class Authenticating extends AuthState {}

class Authenticated extends AuthState {
  User userdata;
  Authenticated(this.userdata);
}

class UnAuthenticated extends AuthState {}

class Failed extends AuthState {
  String? msg;
  Failed(this.msg);
}
