class AlbumResponse {
  List<Albums>? albums;
  String? nextPageToken;

  AlbumResponse({this.albums, this.nextPageToken});

  AlbumResponse.fromJson(Map<String, dynamic> json) {
    if (json['albums'] != null) {
      albums = <Albums>[];
      json['albums'].forEach((v) {
        albums?.add(new Albums.fromJson(v));
      });
    }
    nextPageToken = json['nextPageToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.albums != null) {
      data['albums'] = this.albums?.map((v) => v.toJson()).toList();
    }
    data['nextPageToken'] = this.nextPageToken;
    return data;
  }
}

class Albums {
  String? id;
  String? title;
  String? productUrl;
  String? mediaItemsCount;
  String? coverPhotoBaseUrl;
  String? coverPhotoMediaItemId;

  Albums(
      {this.id,
        this.title,
        this.productUrl,
        this.mediaItemsCount,
        this.coverPhotoBaseUrl,
        this.coverPhotoMediaItemId});

  Albums.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    productUrl = json['productUrl'];
    mediaItemsCount = json['mediaItemsCount'];
    coverPhotoBaseUrl = json['coverPhotoBaseUrl'];
    coverPhotoMediaItemId = json['coverPhotoMediaItemId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['productUrl'] = this.productUrl;
    data['mediaItemsCount'] = this.mediaItemsCount;
    data['coverPhotoBaseUrl'] = this.coverPhotoBaseUrl;
    data['coverPhotoMediaItemId'] = this.coverPhotoMediaItemId;
    return data;
  }
}
