import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery_photos/model/upload_token_model.dart';
import 'package:gallery_photos/request/create_media_request.dart';
import 'package:gallery_photos/response/create_album_response.dart';
import 'package:gallery_photos/response/create_media_response.dart';
import 'package:gallery_photos/ui/loading_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CreateAlbumPage extends StatefulWidget {
  final String? title;

  const CreateAlbumPage({Key? key, this.title}) : super(key: key);

  @override
  _CreateAlbumPageState createState() => _CreateAlbumPageState();
}

class _CreateAlbumPageState extends State<CreateAlbumPage> {
  final TextEditingController controller = TextEditingController();
  List<File>? _files = [];
  List<UploadTokenModel> uploadTokens = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title ?? "",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  focusNode: FocusNode(),
                  decoration: InputDecoration(
                      hintText: "Thêm tiêu đề",
                      hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.4), fontSize: 20),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black26))),
                ),
                SizedBox(
                  height: 12,
                ),
                Expanded(child: _buildPickedAlbum),
                SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    await _pickImage();
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.add,
                            color: Colors.black.withOpacity(0.4),
                          ),
                        ),
                        Text(
                          "Chọn ảnh",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => onClick(),
                    child: Text("Tải lên"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _buildPickedAlbum {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: this._files?.length ?? 0,
      itemBuilder: (BuildContext context, int index) => Image.file(
        this._files![index],
        fit: BoxFit.cover,
      ),
      staggeredTileBuilder: (int index) =>
          StaggeredTile.count(2, index.isEven ? 2 : 1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();
    _files = images?.map((e) => File(e.path)).toList();
  }

  Future<void> onClick() async {
    if (this.controller.text.isEmpty) {
      return;
    }
    this._showLoading();
    CreateAlbumResponse _album = await this._createAlbum(this.controller.text);
    await this._getUploadTokens();
    await this._createMedia(await _createRequest(_album.id ?? ""));
    this._closeLoading();
    Navigator.pop(context, true);
  }

  Future<void> _getUploadTokens() async {
    List<File> _files = this._files ?? [];
    await Future.forEach(_files, (element) async {
      String _uploadToken = await _uploadMediaItem(element as File);
      uploadTokens.add(UploadTokenModel(
          uploadToken: _uploadToken,
          fileName: path.basename(element.path),
          description: "description" + path.basename(element.path)));
    });
  }

  Future<CreateMediaRequest> _createRequest(String albumId) async {
    final request = CreateMediaRequest(albumId: albumId, newMediaItems: []);
    await Future.forEach(
        uploadTokens,
        (element) async => request.newMediaItems?.add(NewMediaItems(
            description: (element as UploadTokenModel).description,
            simpleMediaItem: SimpleMediaItem(
                fileName: element.fileName,
                uploadToken: element.uploadToken))));
    return request;
  }

  Future<String> _uploadMediaItem(File image) async {
    // Get the filename of the image
    final filename = path.basename(image.path);

    // Set up the headers required for this request.
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    final String _auth = sharedPreference.getString("auth") ?? "";
    final Map<String, String> _authHeaders =
        Map<String, String>.from(json.decode(_auth));
    final headers = <String, String>{};
    headers.addAll(_authHeaders);
    headers['Content-type'] = 'application/octet-stream';
    headers['X-Goog-Upload-Protocol'] = 'raw';
    headers['X-Goog-Upload-File-Name'] = filename;

    // Make the HTTP request to upload the image. The file is sent in the body.
    final response = await http.post(
      Uri.parse('https://photoslibrary.googleapis.com/v1/uploads'),
      body: image.readAsBytesSync(),
      headers: _authHeaders,
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    throw response.body;
  }

  Future<CreateItemResponse> _createMedia(CreateMediaRequest request) async {
    final url = Uri.parse(
        "https://photoslibrary.googleapis.com/v1/mediaItems:batchCreate");
    final headers = await _buildHeader();
    final body = json.encode(request.toJson());

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseJson = response.body;
      final _response = CreateItemResponse.fromJson(json.decode(responseJson));
      return _response;
    }
    throw response.body;
  }

  Future<CreateAlbumResponse> _createAlbum(String title) async {
    final url = Uri.parse("https://photoslibrary.googleapis.com/v1/albums");
    final _header = await _buildHeader();
    final Map<String, dynamic> request = Map<String, dynamic>();
    final Map<String, dynamic> _albumRequest = new Map<String, dynamic>();
    _albumRequest['title'] = title;
    request['album'] = _albumRequest;
    final body = json.encode(request);
    final response = await http.post(url, headers: _header, body: body);
    if (response.statusCode == 200) {
      final responseJson = response.body;
      final _response = CreateAlbumResponse.fromJson(json.decode(responseJson));
      return _response;
    }
    throw response.body;
  }

  void _showLoading() {
    showDialog(context: context, builder: (context) => LoadingDialog());
  }

  void _closeLoading() {
    Navigator.pop(context);
  }

  Future<Map<String, String>> _buildHeader() async {
    SharedPreferences sharedPreference = await SharedPreferences.getInstance();
    final String _auth = sharedPreference.getString("auth") ?? "";
    final Map<String, String> _authHeaders =
        Map<String, String>.from(json.decode(_auth));
    final headers = <String, String>{};
    headers.addAll(_authHeaders);
    return headers;
  }
}
