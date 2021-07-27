class CreateItemResponse {
  List<NewMediaItemResults>? newMediaItemResults;

  CreateItemResponse({this.newMediaItemResults});

  CreateItemResponse.fromJson(Map<String, dynamic> json) {
    if (json['newMediaItemResults'] != null) {
      newMediaItemResults = <NewMediaItemResults>[];
      json['newMediaItemResults'].forEach((v) {
        newMediaItemResults?.add(new NewMediaItemResults.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.newMediaItemResults != null) {
      data['newMediaItemResults'] =
          this.newMediaItemResults?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewMediaItemResults {
  String? uploadToken;
  Status? status;
  MediaItem? mediaItem;

  NewMediaItemResults({this.uploadToken, this.status, this.mediaItem});

  NewMediaItemResults.fromJson(Map<String, dynamic> json) {
    uploadToken = json['uploadToken'];
    status =
        json['status'] != null ? new Status.fromJson(json['status']) : null;
    mediaItem = json['mediaItem'] != null
        ? new MediaItem.fromJson(json['mediaItem'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uploadToken'] = this.uploadToken;
    if (this.status != null) {
      data['status'] = this.status?.toJson();
    }
    if (this.mediaItem != null) {
      data['mediaItem'] = this.mediaItem?.toJson();
    }
    return data;
  }
}

class Status {
  String? message;

  Status({this.message});

  Status.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}

class MediaItem {
  String? id;
  String? description;
  String? productUrl;
  String? mimeType;
  MediaMetadata? mediaMetadata;
  String? filename;

  MediaItem(
      {this.id,
      this.description,
      this.productUrl,
      this.mimeType,
      this.mediaMetadata,
      this.filename});

  MediaItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    productUrl = json['productUrl'];
    mimeType = json['mimeType'];
    mediaMetadata = json['mediaMetadata'] != null
        ? new MediaMetadata.fromJson(json['mediaMetadata'])
        : null;
    filename = json['filename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['productUrl'] = this.productUrl;
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

  MediaMetadata({this.creationTime, this.width, this.height});

  MediaMetadata.fromJson(Map<String, dynamic> json) {
    creationTime = json['creationTime'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creationTime'] = this.creationTime;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}
