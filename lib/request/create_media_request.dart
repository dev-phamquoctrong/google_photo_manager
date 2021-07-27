class CreateMediaRequest {
  List<NewMediaItems>? newMediaItems;
  String? albumId;

  CreateMediaRequest({this.newMediaItems, this.albumId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.albumId != null) {
      data['albumId'] = this.albumId;
    }
    if (this.newMediaItems != null) {
      data['newMediaItems'] =
          this.newMediaItems?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewMediaItems {
  String? description;
  SimpleMediaItem? simpleMediaItem;

  NewMediaItems({this.description, this.simpleMediaItem});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    if (this.simpleMediaItem != null) {
      data['simpleMediaItem'] = this.simpleMediaItem?.toJson();
    }
    return data;
  }
}

class SimpleMediaItem {
  String? fileName;
  String? uploadToken;

  SimpleMediaItem({this.fileName, this.uploadToken});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileName'] = this.fileName;
    data['uploadToken'] = this.uploadToken;
    return data;
  }
}
