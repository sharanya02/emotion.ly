import 'dart:io';
import 'package:emotionly/api/api.dart';
import 'package:emotionly/screens/auth/auth_screen.dart';
import 'package:emotionly/screens/call/result.dart';
import 'package:emotionly/utils/common.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  Profile({
    @required this.name,
    @required this.email,
    @required this.avatarUrl,
  });
  final String name;
  final String email;
  final String avatarUrl;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Common _common;
  ScrollController _outerScrollController;
  ScrollController _innerScrollController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _common.background,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            controller: _outerScrollController,
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                AppName(common: _common, fontSize: 32),
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                ProfileUserDetailsWidget(
                  common: _common,
                  name: widget.name,
                  email: widget.email,
                  avatarUrl: widget.avatarUrl,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.07),
                Text("Meetings:",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 20,
                        color: Colors.white)),
                ListView.separated(
                  shrinkWrap: true,
                  controller: _innerScrollController,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => Result())),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      decoration: BoxDecoration(
                        color: _common.container,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Meeting id: xyz-abc-lmn",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "5 April 2021",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 17,
                                  color: _common.blue,
                                ),
                              ),
                              Text(
                                "21:00:00",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 17,
                                  color: _common.purple,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.transparent,
                    thickness: 0,
                    height: 15,
                  ),
                  itemCount: 5,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _common = Common();
    _outerScrollController = ScrollController();
    _innerScrollController = ScrollController();

    _innerScrollController.addListener(
        () => _outerScrollController.jumpTo(_innerScrollController.offset));
    super.initState();
  }
}

class ProfileUserDetailsWidget extends StatefulWidget {
  ProfileUserDetailsWidget({
    @required this.common,
    @required this.name,
    @required this.email,
    @required this.avatarUrl,
  });
  final Common common;
  final String name;
  final String email;
  final String avatarUrl;

  @override
  _ProfileUserDetailsWidgetState createState() =>
      _ProfileUserDetailsWidgetState();
}

class _ProfileUserDetailsWidgetState extends State<ProfileUserDetailsWidget> {
  String avatarUrl = "";
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  FilePickerResult result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    File image = File(result.files.single.path);
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    await ApiService()
                        .updateUserAvatar(pref.getString("token"), image)
                        .then((result) async {
                      if (result["avatarUrl"] != null) {
                        setState(
                          () => avatarUrl = result["avatarUrl"],
                        );
                        return widget.common
                            .displayToast("Avatar updated!", context);
                      } else if (result["message"] != null)
                        return widget.common
                            .displayToast(result["message"], context);
                    });
                  } else
                    return widget.common
                        .displayToast("Avatar change cancelled", context);
                },
                child: ClipOval(
                  child: SizedBox(
                    height: 110,
                    width: 110,
                    child: Image.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Tap to edit",
                style: TextStyle(fontFamily: "Poppins", color: Colors.white),
              ),
            ],
          ),
        ),
        SizedBox(width: 40),
        Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: "Poppins", fontSize: 28, color: Colors.white),
              ),
              Text(
                widget.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  pref.remove("token").whenComplete(() {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, _, __) => AuthScreen()));
                  });
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 20, vertical: 5)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  backgroundColor:
                      MaterialStateProperty.all(widget.common.blue),
                ),
                child: Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    avatarUrl = widget.avatarUrl;
    super.initState();
  }
}
