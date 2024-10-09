import 'package:flutter/material.dart';
import 'package:together/Objects/user_detail.dart';

class AuthCredentialProvider extends ChangeNotifier {
  bool isLoggined;
  UserDetail userDetail = UserDetail();

  AuthCredentialProvider({
    this.isLoggined = false,
  });

  void setUserDetails(UserDetail user) {
    userDetail = user;
    notifyListeners();
  }

  void setLogined(bool val) {
    isLoggined = val;
    notifyListeners();
  }
}
