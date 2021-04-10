import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:emotionly/api/api.dart';
import 'package:emotionly/screens/call/call.dart';
import 'package:emotionly/screens/profile/profile.dart';
import 'package:emotionly/utils/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Common _common;
  TextEditingController _meetingCodeController;
  ApiService _apiService;
  String name = "", email = "", avatarUrl = "";
  int uid = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: _common.background,
      appBar: AppBar(
        leading: Container(),
        backgroundColor: _common.background,
        elevation: 0,
        centerTitle: true,
        title: AppName(common: _common, fontSize: 32),
        actions: [
          FutureBuilder(
            future: getUserDetails(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return CircleAvatar(backgroundColor: _common.blueLight);

              if (snapshot.hasError)
                return Icon(Icons.error, color: Colors.white);

              if (snapshot.hasData)
                return GestureDetector(
                  onTap: () async => await Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => Profile(
                        name: snapshot.data["user"]["name"],
                        email: snapshot.data["user"]["email"],
                        avatarUrl: snapshot.data["user"]["avatar"],
                      ),
                    ),
                  ).whenComplete(() {
                    getUserDetails();
                    setState(() {});
                  }),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      snapshot.data["user"]["avatar"],
                    ),
                  ),
                );
              return Container();
            },
          ),
          SizedBox(width: 15),
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Colors.white, style: BorderStyle.solid, width: 2),
                color: _common.container),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                        ),
                        HomeTitle(common: _common),
                        Text("Meeting",
                            style: TextStyle(
                                fontSize: 30,
                                fontFamily: "Poppins",
                                color: Colors.white)),
                        Flexible(
                          child: SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                        ),
                        TextButton(
                          onPressed: () {
                            return onJoin(true);
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              backgroundColor:
                                  MaterialStateProperty.all(_common.purple),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(vertical: 10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_outline,
                                  color: Colors.white),
                              SizedBox(width: 10),
                              Text("Create a new meeting",
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 18,
                                      color: Colors.white))
                            ],
                          ),
                        ),
                        Flexible(
                            child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05)),
                        TextField(
                          controller: _meetingCodeController,
                          style: TextStyle(
                              color: Colors.white, fontFamily: "Poppins"),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              child: Icon(Icons.call_outlined,
                                  color: _common.blue),
                              onTap: () => onJoin(false),
                            ),
                            fillColor: _common.background,
                            filled: true,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: _common.blue),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white),
                              gapPadding: 30,
                            ),
                            hintText: "Enter meeting code",
                            hintStyle: TextStyle(
                                color: _common.blue, fontFamily: "Poppins"),
                          ),
                        ),
                        Flexible(
                          child: SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  child: Image.asset(
                    "assets/cartoons.png",
                    fit: BoxFit.cover,
                    frameBuilder: (BuildContext context, Widget child,
                        int frame, bool wasSynchronouslyLoaded) {
                      return child;
                    },
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
    _common = Common();
    _apiService = ApiService();
    _meetingCodeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _meetingCodeController.dispose();
    super.dispose();
  }

  Future getUserDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    final result = await _apiService.getUserDetails(pref.getString("token"));

    if (result["message"] != null)
      return result;
    else if (result["user"] != null) {
      name = result["user"]["name"];
      email = result["user"]["email"];
      avatarUrl = result["user"]["avatar"];
      uid = result["user"]["id"];

      return result;
    }
  }

  Future<void> onJoin(bool created) async {
    FocusScope.of(context).unfocus();
    if ((_meetingCodeController.text.isNotEmpty && !created) || (created)) {
      _common.displayToast("Entering meeting...", context);
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);

      SharedPreferences pref = await SharedPreferences.getInstance();
      print(pref.getString("token"));
      if (created) {
        await _apiService
            .createMeeting(pref.getString("token"))
            .then((result) async {
          print(pref.getString("token"));
          if (result["message"] != null)
            return _common.displayToast(result["message"], context);

          if (result["meetingDetails"] != null) {
            final String channel = result["meetingDetails"]["channel"];
            final String token = result["meetingDetails"]["token"];
            final int mid = result["meetingDetails"]["mid"];
            final int uid = result["meetingDetails"]["uid"];
            print("TOKEN - $token");

            await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => CallPage(
                  channelName: channel,
                  role: ClientRole.Broadcaster,
                  token: token,
                  mid: mid,
                  uid: uid,
                ),
              ),
            );
          }
        });
      } else {
        await _apiService
            .joinMeeting(pref.getString("token"), _meetingCodeController.text)
            .then((result) async {
          if (result["message"] != null) {
            return _common.displayToast(result["message"], context);
          } else if (result["meetingDetails"] != null) {
            final String token = result["meetingDetails"]["token"];
            final int mid = result["meetingDetails"]["mid"];
            await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => CallPage(
                  channelName: _meetingCodeController.text,
                  role: ClientRole.Broadcaster,
                  token: token,
                  mid: mid,
                  uid: uid,
                ),
              ),
            );
          }
        });
      }
    } else
      _common.displayToast("Empty meeting code", context);
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}

class HomeTitle extends StatelessWidget {
  const HomeTitle({
    Key key,
    @required Common common,
  })  : _common = common,
        super(key: key);

  final Common _common;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Create",
            style: TextStyle(
                fontSize: 30, fontFamily: "Poppins", color: _common.purple)),
        Flexible(child: SizedBox(width: 15)),
        Text("or",
            style: TextStyle(
                fontSize: 30, fontFamily: "Poppins", color: Colors.white)),
        Flexible(child: SizedBox(width: 15)),
        Text("Join",
            style: TextStyle(
                fontSize: 30, fontFamily: "Poppins", color: _common.blue)),
        Flexible(child: SizedBox(width: 15)),
        Text("a",
            style: TextStyle(
                fontSize: 30, fontFamily: "Poppins", color: Colors.white)),
      ],
    );
  }
}
