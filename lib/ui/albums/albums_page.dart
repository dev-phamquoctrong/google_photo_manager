import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gallery_photos/response/album_response.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AlbumsPage extends StatefulWidget {
  const AlbumsPage({Key? key, @required this.googleSignInAccount})
      : super(key: key);
  final GoogleSignInAccount? googleSignInAccount;

  @override
  _AlbumsPageState createState() => _AlbumsPageState();
}

class _AlbumsPageState extends State<AlbumsPage> {
  List<Albums> albums = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    albums = await this._getAlbums();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Albums",
          style: TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: albums.isNotEmpty
            ? Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: GridView.builder(
                        itemCount: albums.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.5),
                        itemBuilder: (context, position) =>
                            _buildItem(albums[position])),
                  ),
                ],
              )
            : Container(),
      ),
    );
  }

  Widget _buildItem(Albums albums) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            albums.coverPhotoBaseUrl ?? "",
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            albums.title ?? "",
            style: TextStyle(
                color: Color(0xff666666),
                fontSize: 14,
                fontWeight: FontWeight.w500),
          )
        ],
      );

  Future<List<Albums>> _getAlbums() async {
    List<Albums> _result = [];
    final _shared = await SharedPreferences.getInstance();
    final _json = _shared.getString("auth");
    final Map<String, String> _header =
        json.decode(_json ?? "").cast<String, String>();
    final url = Uri.parse("https://photoslibrary.googleapis.com/v1/albums?");
    final response = await http.get(url, headers: _header);
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      _result = (responseJson['albums'] as List)
          .map((e) => Albums.fromJson(e))
          .toList();
    }
    return _result;
  }
}
