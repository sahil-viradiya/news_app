// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:haveliapp/auth/auth_cubit.dart';

final storage = FlutterSecureStorage();
AuthCubit authCubit =AuthCubit();

String? TOKEN;

Future<void> storeToken(String token) async {
  TOKEN = token;
  await storage.write(key: "token", value: token);
}

Future<void> getToken() async {
  TOKEN = await storage.read(key: "token");
}

Future<void> deletToken()async{
  TOKEN = null;
  await storage.delete(key: "token");
}