class CreateAlbumResponse {
  String? productUrl;
  String? id;
  String? title;
  bool? isWriteable;

  CreateAlbumResponse({this.productUrl, this.id, this.title, this.isWriteable});

  CreateAlbumResponse.fromJson(Map<String, dynamic> json) {
    productUrl = json['productUrl'];
    id = json['id'];
    title = json['title'];
    isWriteable = json['isWriteable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productUrl'] = this.productUrl;
    data['id'] = this.id;
    data['title'] = this.title;
    data['isWriteable'] = this.isWriteable;
    return data;
  }
}
