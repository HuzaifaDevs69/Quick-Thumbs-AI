class ThumbnailModel {
  int? status;
  int? counts;
  List<Result>? result;

  ThumbnailModel({this.status, this.counts, this.result});

  ThumbnailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    counts = json['counts'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['counts'] = this.counts;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? thumbnailId;
  String? videoUrl;
  String? imageUrl;
  String? editedImageUrl;
  String? platform;
  String? createdAt;
  String? updatedAt;
  int? userId;
  String? userName;

  Result(
      {this.thumbnailId,
      this.videoUrl,
      this.imageUrl,
      this.editedImageUrl,
      this.platform,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.userName});

  Result.fromJson(Map<String, dynamic> json) {
    thumbnailId = json['ThumbnailId'];
    videoUrl = json['VideoUrl'];
    imageUrl = json['ImageUrl'];
    editedImageUrl = json['EditedImageUrl'];
    platform = json['Platform'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    userId = json['UserId'];
    userName = json['User.Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ThumbnailId'] = this.thumbnailId;
    data['VideoUrl'] = this.videoUrl;
    data['ImageUrl'] = this.imageUrl;
    data['EditedImageUrl'] = this.editedImageUrl;
    data['Platform'] = this.platform;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['UserId'] = this.userId;
    data['User.Name'] = this.userName;
    return data;
  }
}
