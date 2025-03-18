class UserModel {
  int? status;
  String? message;
  int? counts;
  List<Result>? result;

  UserModel({this.status, this.message, this.counts, this.result});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
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
    data['message'] = this.message;
    data['counts'] = this.counts;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? userId;
  String? name;
  String? mobileNo;
  String? createdAt;
  String? updatedAt;

  Result(
      {this.userId, this.name, this.mobileNo, this.createdAt, this.updatedAt});

  Result.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    name = json['Name'];
    mobileNo = json['MobileNo'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['Name'] = this.name;
    data['MobileNo'] = this.mobileNo;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
