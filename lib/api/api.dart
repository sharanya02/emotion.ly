import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  Future createAgoraToken(String channel) async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://crisysagoratokenhost.herokuapp.com/access_token?channel=$channel'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200)
      return jsonDecode(await response.stream.bytesToString());
    else
      print(response.reasonPhrase);
  }

  Future signUpUser(String name, String email, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('http://3.86.104.208:8000/auth/signup'));
    request.body =
        '''{\r\n    "email":"$email",\r\n    "password":"$password",\r\n    "name":"$name"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201)
      return jsonDecode(await response.stream.bytesToString());
    else if (response.statusCode == 500)
      return ("User already exists!");
    else
      print(response.reasonPhrase);
  }

  Future loginUser(String email, String password) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('http://3.86.104.208:8000/auth/login'));
    request.body =
        '''{\r\n    "email":"$email",\r\n    "password":"$password"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200)
      return jsonDecode(await response.stream.bytesToString());
    else if (response.statusCode == 400)
      return jsonDecode(await response.stream.bytesToString());
    else
      print(response.reasonPhrase);
  }

  Future getUserDetails(String authToken) async {
    var headers = {'Authorization': authToken};
    var request =
        http.Request('GET', Uri.parse('http://3.86.104.208:8000/user'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200)
      return jsonDecode(await response.stream.bytesToString());
    else if (response.statusCode == 401)
      return jsonDecode(await response.stream.bytesToString());
    else
      print(response.reasonPhrase);
  }

  Future updateUserAvatar(String authToken, File image) async {
    var headers = {'Authorization': authToken};
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://3.86.104.208:8000/user'));
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200)
      return jsonDecode(await response.stream.bytesToString());
    else
      print(response.reasonPhrase);
  }

  Future createMeeting(String authToken) async {
    var headers = {'Authorization': authToken};
    // http://3.86.104.208:8000
    var request = http.Request(
        'GET', Uri.parse('http://3.86.104.208:8000/meeting/create'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201)
      return jsonDecode(await response.stream.bytesToString());
    else if (response.statusCode == 401)
      return jsonDecode(await response.stream.bytesToString());
    else
      print(response.reasonPhrase);
  }

  Future joinMeeting(String authToken, String channel) async {
    var headers = {
      'Authorization': authToken,
      'Content-Type': 'application/json'
    };
    var request = http.Request(
        'POST', Uri.parse('http://3.86.104.208:8000/meeting/join'));
    request.body = '''{\r\n    "channel":"$channel"\r\n}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200)
      return jsonDecode(await response.stream.bytesToString());
    else if (response.statusCode == 400)
      return jsonDecode(await response.stream.bytesToString());
    else
      print(response.reasonPhrase);
  }
}
