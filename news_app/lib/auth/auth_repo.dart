// ignore_for_file: unused_local_variable

import 'package:dio/dio.dart';
import 'package:haveliapp/constant.dart';
import 'package:haveliapp/utils.dart';

class AuthRepo {
  Future<dynamic> userDetailsApi() async {
    var response = await DIO.get("$BASE_URL/api/userdetails/",
        options: Options(headers: {"Authorization": TOKEN}));
    return response;
  }
}
