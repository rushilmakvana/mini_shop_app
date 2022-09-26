import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/exception.dart';

class Auth with ChangeNotifier {
  String? token;
  DateTime? expirydate;
  String? userId;
  Timer? authTimer;
  String? get Token {
    if (expirydate != null &&
        expirydate!.isAfter(DateTime.now()) &&
        token != null) {
      return token;
    }
  }

  bool get isAuth {
    return Token != null;
  }

  String get uId {
    return userId as String;
  }

  Future<void> _authenticate(String email, String pass, String method) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$method?key=AIzaSyCNr8ft_HETAlsOxmjTFlgAQtpvYKWRIA4';

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': pass,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw httpException(responseData['error']['message']);
      }
      token = responseData['idToken'];
      userId = responseData['localId'];
      expirydate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      autologout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': token,
          'expirydate': expirydate!.toIso8601String(),
          'userId': userId,
        },
      );
      prefs.setString('userData', userData);
      // final demo = prefs.getString('userData');
      // print("test = $demo");
    } catch (err) {
      rethrow;
    }
    // print(json.decode(response.body));
  }

  Future<bool> tryAutoLogin() async {
    print('auto login');
    final pref = await SharedPreferences.getInstance();
    // final demo = json.decode(pref.getString('userData') as String);
    // print("test = $demo");
    if (!pref.containsKey('userData')) {
      return false;
    }
    // print('yesssss');
    final data = json.decode(pref.getString('userData') as String);
    // print(data.runtimeType);
    final date = DateTime.parse(data['expirydate'] as String);
    if (date.isBefore(DateTime.now())) {
      return false;
    }
    // print('called auto login');
    // print(data);
    // print('data - ${data["token"]}');
    // print('data - $expirydate');
    // print('data - ${data["userId"]}');
    token = data['token'] as String;
    expirydate = date;
    userId = data['userId'] as String;
    notifyListeners();
    autologout();
    return true;
    // final extractedData = json.decode(userdata);
  }

  Future<void> login(String email, String pass) async {
    return _authenticate(email, pass, 'signInWithPassword');
    // final url =
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCNr8ft_HETAlsOxmjTFlgAQtpvYKWRIA4';
    // final response=await http.post(Uri.parse(url),body: {})
  }

  Future<void> signup(String email, String pass) async {
    return _authenticate(email, pass, 'signUp');
  }

  Future<void> logout() async {
    // print('logged out');
    token = null;
    userId = null;
    expirydate = null;
    if (authTimer != null) {
      authTimer!.cancel();
      authTimer = null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    // var demo = pref.getString('userData');
    // print("test = $demo");
    pref.clear();
    // demo = pref.getString('userData');
    // print('test 2 $demo');
  }

  void autologout() {
    print('auto logout');
    if (authTimer != null) {
      authTimer!.cancel();
      // authTimer = null;
    }
    final logoutTime = expirydate!.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: logoutTime), logout);
  }
}
