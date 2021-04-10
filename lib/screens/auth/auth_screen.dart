import 'package:emotionly/api/api.dart';
import 'package:emotionly/screens/home/home.dart';
import 'package:emotionly/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Common _common;
  ApiService _apiService;
  PageController _pageController;
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _common.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                AppName(common: _common, fontSize: 44),
                Flexible(child: SizedBox(height: 70)),
                Flexible(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: PageView(
                      controller: _pageController,
                      physics: BouncingScrollPhysics(),
                      children: [
                        Login(
                          pageController: _pageController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          apiService: _apiService,
                          common: _common,
                        ),
                        SignUp(
                          pageController: _pageController,
                          nameController: _nameController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          apiService: _apiService,
                          common: _common,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _common = Common();
    _apiService = ApiService();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class Login extends StatelessWidget {
  Login({
    @required this.pageController,
    @required this.emailController,
    @required this.passwordController,
    @required this.apiService,
    @required this.common,
  });
  final PageController pageController;
  final Common common;
  final ApiService apiService;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // border: Border.all(color: Colors.transparent, width: 2),
          color: common.container),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(flex: 2, child: SizedBox(height: 40)),
          Text(
            "Login",
            style: TextStyle(
                fontFamily: "Poppins", fontSize: 32, color: Colors.white),
          ),
          Flexible(flex: 2, child: SizedBox(height: 40)),
          TextField(
            controller: emailController,
            style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              fillColor: common.background,
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white),
              ),
              hintText: "Email or username",
              hintStyle: TextStyle(color: Colors.grey, fontFamily: "Poppins"),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: passwordController,
            style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecoration(
              fillColor: common.background,
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white),
                gapPadding: 30,
              ),
              hintText: "Password",
              hintStyle: TextStyle(color: Colors.grey, fontFamily: "Poppins"),
            ),
          ),
          Flexible(child: SizedBox(height: 30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Dont have an account?",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 6),
              TextButton(
                onPressed: () => pageController.animateToPage(1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.decelerate),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: common.blue,
                  ),
                ),
              ),
            ],
          ),
          Flexible(child: SizedBox(height: 30)),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isNotEmpty &&
                  passwordController.text.isNotEmpty) {
                final result = await apiService.loginUser(
                    emailController.text, passwordController.text);
                if (result["message"] != null) {
                  common.displayToast(result["message"], context);
                } else if (result["token"] != null) {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString("token", result["token"]).whenComplete(() {
                    common.displayToast("Logged in successfully", context);
                    return Navigator.pushReplacement(context,
                        CupertinoPageRoute(builder: (context) => Home()));
                  });
                }
              } else {
                common.displayToast("Email or password is empty!", context);
              }
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 40, vertical: 8)),
                elevation: MaterialStateProperty.all(5),
                backgroundColor: MaterialStateProperty.all(common.purple)),
            child: Text("Login",
                style: TextStyle(
                    color: Colors.white, fontFamily: "Poppins", fontSize: 17)),
          ),
          Flexible(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

class SignUp extends StatelessWidget {
  SignUp({
    @required this.pageController,
    @required this.nameController,
    @required this.emailController,
    @required this.passwordController,
    @required this.apiService,
    @required this.common,
  });
  final PageController pageController;
  final Common common;
  final ApiService apiService;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // border: Border.all(color: _common.purple, width: 2),
          color: common.container),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(flex: 2, child: SizedBox(height: 40)),
          Text(
            "Sign Up",
            style: TextStyle(
                fontFamily: "Poppins", fontSize: 32, color: Colors.white),
          ),
          Flexible(flex: 2, child: SizedBox(height: 40)),
          TextField(
            controller: nameController,
            style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              fillColor: common.background,
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white),
              ),
              hintText: "Name",
              hintStyle: TextStyle(color: Colors.grey, fontFamily: "Poppins"),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: emailController,
            style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              fillColor: common.background,
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white),
              ),
              hintText: "Email or username",
              hintStyle: TextStyle(color: Colors.grey, fontFamily: "Poppins"),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: passwordController,
            style: TextStyle(color: Colors.white, fontFamily: "Poppins"),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: InputDecoration(
              fillColor: common.background,
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.white),
                gapPadding: 30,
              ),
              hintText: "Password",
              hintStyle: TextStyle(color: Colors.grey, fontFamily: "Poppins"),
            ),
          ),
          Flexible(child: SizedBox(height: 30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account?",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () => pageController.animateToPage(0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.decelerate),
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: common.blue,
                  ),
                ),
              ),
            ],
          ),
          Flexible(child: SizedBox(height: 30)),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isNotEmpty &&
                  passwordController.text.isNotEmpty &&
                  nameController.text.isNotEmpty) {
                final result = await apiService.signUpUser(nameController.text,
                    emailController.text, passwordController.text);
                if (result == "User already exists!") {
                  common.displayToast("User already exists!", context);
                } else if (result["token"] != null) {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.setString("token", result["token"]).whenComplete(() {
                    common.displayToast("Signed up successfully", context);
                    return Navigator.pushReplacement(context,
                        CupertinoPageRoute(builder: (context) => Home()));
                  });
                }
              } else {
                common.displayToast("Some fields are empty!", context);
              }
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 40, vertical: 8)),
                elevation: MaterialStateProperty.all(5),
                backgroundColor: MaterialStateProperty.all(common.purple)),
            child: Text("Sign Up",
                style: TextStyle(
                    color: Colors.white, fontFamily: "Poppins", fontSize: 17)),
          ),
          Flexible(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}
