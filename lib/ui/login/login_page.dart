import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gallery_photos/ui/albums/albums_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGooglePhotoLogo,
            _buildConnectButton,
          ],
        ),
      ),
    );
  }

  Widget get _buildGooglePhotoLogo => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/ic_google_photo.png",
            width: 50,
            height: 50,
          ),
          Text(
            "HIKO Photos",
            style:
                TextStyle(fontSize: 20, color: Colors.black.withOpacity(0.8)),
          )
        ],
      );

  Widget get _buildConnectButton => TextButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.blue)),
      onPressed: () async {
        await this.onClickLogin();
      },
      child: Text(
        "Connect with Google photo",
        style: TextStyle(color: Colors.white),
      ));

  GoogleSignIn get _googleSignIn => GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/photoslibrary.readonly',
          'https://www.googleapis.com/auth/photoslibrary.appendonly',
          'https://www.googleapis.com/auth/photoslibrary.edit.appcreateddata'
        ],
      );

  Future<GoogleSignInAccount?> _handleSignIn() async {
    GoogleSignInAccount? result;
    try {
      result = await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
    return result;
  }

  Future<void> onClickLogin() async {
    GoogleSignInAccount? result = await this._handleSignIn();
    if (result != null) {
      SharedPreferences sharedPreference =
          await SharedPreferences.getInstance();
      final _header = await result.authHeaders;
      sharedPreference.setString("auth", json.encode(_header));
      print("============ ${_header.toString()}");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AlbumsPage(googleSignInAccount: result)));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Error"),
                content: Text("Authentication error"),
              ));
    }
  }
}
