  import 'package:dio/dio.dart' as Dio;
import 'package:fatwa/models/user.dart';
import 'package:fatwa/services/dio.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth extends ChangeNotifier {
  bool _isLoggedIn = false;
  late User _user;
  late String _token;
  bool get authenticated => _isLoggedIn;
  User get user => _user;
  static bool isauthenticated=false;
  static String rep = '';

  final storage = new FlutterSecureStorage();

  void login({Map? creds}) async {
    print(creds);

    try {
      Dio.Response response = await dio().post('/sanctum/token', data: creds);
      print(response.data.toString());
      if (response.data =='email or mot de pass incorrect'){
        isauthenticated=false;
        response = response.data;
      }else {
      String token = response.data.toString();
      this.tryToken(token: token);
      isauthenticated=true;
      }

    } catch (e) {
      print(e);
    }
  }

  void tryToken({String? token}) async {
    if (token == null) {
      return;
    } else {
      try {
        Dio.Response response = await dio().get('/user',
            options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        this._isLoggedIn = true;
        this._user = User.fromJson(response.data);
        this._token = token;
        this.storeToken(token: token);
        notifyListeners();
        print(_user);
      } catch (e) {
        print(e);
      }
    }
  }

  // void getFollow({String? token}) async{
  //   if(token == null){
  //     return;
  //   }
  //   else{
  //     try {
  //        Dio.Response response = await dio().get('/follows',
  //       options: Dio.Options(
  //         headers: {'Authorization': 'Bearer $token'}));
  //         this.follow = Follow.fromJson(response.data);
  //                 notifyListeners();

  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  // }

  void storeToken({String? token}) async {
    this.storage.write(key: 'token', value: token);
  }

  void logout() async {
    try {
      Dio.Response response = await dio().get('/user/revoke',
          options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      cleanUp();
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void cleanUp() async {
    this._isLoggedIn = false;
    // this._user = null;
    // this._token = null;

    await storage.delete(key: 'token');
  }

  // void update({Map? updt, String ? token}) async {
  //   print(updt);

  //     Dio.Response response = await dio().post('/update_informations',
  //         options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
  // }
}
