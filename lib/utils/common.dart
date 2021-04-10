import 'package:flutter/material.dart';

class Common {
  Color background = Color(0XFF1B1E27);
  Color purple = Color(0XFF9673FF);
  Color purpleLight = Color(0XFFB69DFF);
  Color purpleLighter = Color(0XFFD2C2FF);
  Color blue = Color(0XFF57BAFF);
  Color container = Color(0XFF252A36);
  Color blueLight = Color(0XFF80CAFE);
  Color blueLighter = Color(0XFF90D2FF);
  Color blueLightest = Color(0XFFB1DEFD);

  displayToast(String text, BuildContext context) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: Duration(milliseconds: 800),
          backgroundColor: Colors.black,
          content: Text(text,
              style: TextStyle(fontFamily: "Poppins", color: Colors.white))));

  CircularProgressIndicator progressIndicator() => CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(blue),
      );
}

class AppName extends StatelessWidget {
  AppName({@required this.common, @required this.fontSize});
  final Common common;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Emotion",
            style: TextStyle(
                fontFamily: "Nexa", color: common.purple, fontSize: fontSize)),
        Text(".ly",
            style: TextStyle(
                fontFamily: "Nexa", color: common.blue, fontSize: fontSize))
      ],
    );
  }
}
