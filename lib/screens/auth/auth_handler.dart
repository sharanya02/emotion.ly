import 'package:emotionly/screens/auth/auth_loading.dart';
import 'package:emotionly/screens/auth/auth_screen.dart';
import 'package:emotionly/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHandler {
  handleAuth() {
    return FutureBuilder(
      future: getAuthStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Loading(text: "Loading...");
        }

        if (snapshot.hasError) {
          return Loading(text: "Some error occurred");
        }

        if (snapshot.hasData) {
          if (snapshot.data == true)
            return Home();
          else
            return AuthScreen();
        }

        return Container();
      },
    );
  }

  Future<bool> getAuthStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.containsKey("token")) return true;

    return false;
  }
}
