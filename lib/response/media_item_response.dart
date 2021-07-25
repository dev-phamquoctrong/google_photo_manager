class MediaItemResponse {
  List<MediaItems>? mediaItems;
  String? nextPageToken;

  MediaItemResponse({this.mediaItems, this.nextPageToken});

  MediaItemResponse.fromJson(Map<String, dynamic> json) {
    if (json['mediaItems'] != null) {
      mediaItems = <MediaItems>[];
      json['mediaItems'].forEach((v) {
        mediaItems?.add(new MediaItems.fromJson(v));
      });
    }
    nextPageToken = json['nextPageToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mediaItems != null) {
      data['mediaItems'] = this.mediaItems?.map((v) => v.toJson()).toList();
    }
    data['nextPageToken'] = this.nextPageToken;
    return data;
  }
}

class MediaItems {
  String? id;
  String? productUrl;
  String? baseUrl;
  String? mimeType;
  MediaMetadata? mediaMetadata;
  String? filename;

  MediaItems(
      {this.id,
        this.productUrl,
        this.baseUrl,
        this.mimeType,
        this.mediaMetadata,
        this.filename});

  MediaItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productUrl = json['productUrl'];
    baseUrl = json['baseUrl'];
    mimeType = json['mimeType'];
    mediaMetadata = json['mediaMetadata'] != null
        ? new MediaMetadata.fromJson(json['mediaMetadata'])
        : null;
    filename = json['filename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productUrl'] = this.productUrl;
    data['baseUrl'] = this.baseUrl;
    data['mimeType'] = this.mimeType;
    if (this.mediaMetadata != null) {
      data['mediaMetadata'] = this.mediaMetadata?.toJson();
    }
    data['filename'] = this.filename;
    return data;
  }
}

class MediaMetadata {
  String? creationTime;
  String? width;
  String? height;
  Photo? photo;
  Video? video;

  MediaMetadata(
      {this.creationTime, this.width, this.height, this.photo, this.video});

  MediaMetadata.fromJson(Map<String, dynamic> json) {
    creationTime = json['creationTime'];
    width = json['width'];
    height = json['height'];
    photo = json['photo'] != null ? new Photo.fromJson(json['photo']) : null;
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creationTime'] = this.creationTime;
    data['width'] = this.width;
    data['height'] = this.height;
    if (this.photo != null) {
      data['photo'] = this.photo?.toJson();
    }
    if (this.video != null) {
      data['video'] = this.video?.toJson();
    }
    return data;
  }
}

class Photo {
  String? cameraMake;
  String? cameraModel;
  double? focalLength;
  double? apertureFNumber;
  int? isoEquivalent;
  String? exposureTime;

  Photo(
      {this.cameraMake,
        this.cameraModel,
        this.focalLength,
        this.apertureFNumber,
        this.isoEquivalent,
        this.exposureTime});

  Photo.fromJson(Map<String, dynamic> json) {
    cameraMake = json['cameraMake'];
    cameraModel = json['cameraModel'];
    focalLength = json['focalLength'];
    apertureFNumber = json['apertureFNumber'];
    isoEquivalent = json['isoEquivalent'];
    exposureTime = json['exposureTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cameraMake'] = this.cameraMake;
    data['cameraModel'] = this.cameraModel;
    data['focalLength'] = this.focalLength;
    data['apertureFNumber'] = this.apertureFNumber;
    data['isoEquivalent'] = this.isoEquivalent;
    data['exposureTime'] = this.exposureTime;
    return data;
  }
}

class Video {
  double? fps;
  String? status;

  Video({this.fps, this.status});

  Video.fromJson(Map<String, dynamic> json) {
    fps = json['fps'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fps'] = this.fps;
    data['status'] = this.status;
    return data;
  }
}
