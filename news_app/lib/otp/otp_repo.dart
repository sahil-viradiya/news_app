// ignore_for_file: avoid_print

import 'package:haveliapp/constant.dart';

class OtpRepo {
  Future<dynamic> verifyOtp(String otp, String phone) async {
    print(otp);
    var response = await DIO.post(
      "$BASE_URL/api/verifyotp/",
      data: {"phone": phone, "otp": otp},
    );
    return response;
  }

  Future<dynamic> resendOtpApi(String phone) async {
    print(phone);
    var response =
        await DIO.post("$BASE_URL/api/getotp/", data: {"phone": phone});
    return response;
  }
}
