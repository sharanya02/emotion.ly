import 'package:emotionly/utils/common.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  Loading({@required this.text});
  final String text;
  final Common _common = Common();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _common.background,
      appBar: AppBar(
        centerTitle: true,
        title: AppName(common: _common, fontSize: 32),
        backgroundColor: _common.background,
        elevation: 0,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/cartoons.png",
              fit: BoxFit.cover,
            ),
            Flexible(child: SizedBox(height: 40)),
            Text(
              text,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
