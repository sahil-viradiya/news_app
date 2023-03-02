// ignore_for_file: avoid_print

import '../constant.dart';

class PhoneRepo {
  Future<dynamic> getOtpApi(String phone) async {
    print(phone);
    var response =
        await DIO.post("$BASE_URL/api/getotp/", data: {"phone": phone});
    return response;
  }
}
