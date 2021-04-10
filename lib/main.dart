import 'package:emotionly/screens/auth/auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

Future main() async {
  await DotEnv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emotion.ly',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
          tooltipTheme:
              TooltipThemeData(decoration: BoxDecoration(color: Colors.white))),
      home: AuthHandler().handleAuth(),
    );
  }
}
