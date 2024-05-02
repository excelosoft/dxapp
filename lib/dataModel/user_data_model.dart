
class UserDataModel {
  int? status;
  Data? data;
  String? message;

  UserDataModel({this.status, this.data, this.message});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    if(json["status"] is int) {
      status = json["status"];
    }
    if(json["data"] is Map) {
      data = json["data"] == null ? null : Data.fromJson(json["data"]);
    }
    if(json["message"] is String) {
      message = json["message"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    if(data != null) {
      _data["data"] = data?.toJson();
    }
    _data["message"] = message;
    return _data;
  }
}

class Data {
  String? name;
  String? email;
  String? mobile;
  String? pan;
  String? dateOfBirth;
  String? gender;
  String? address;
  String? bio;
  String? avatar;
  String? companyName;
  String? companyType;
  String? companyEmail;
  String? companyPhone;
  String? companyGst;
  String? companyAddress;

  Data({this.name, this.email, this.mobile, this.pan, this.dateOfBirth, this.gender, this.address, this.bio, this.avatar, this.companyName, this.companyType, this.companyEmail, this.companyPhone, this.companyGst, this.companyAddress});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["email"] is String) {
      email = json["email"];
    }
    if(json["mobile"] is String) {
      mobile = json["mobile"];
    }
    if(json["pan"] is String) {
      pan = json["pan"];
    }
    if(json["date_of_birth"] is String) {
      dateOfBirth = json["date_of_birth"];
    }
    if(json["gender"] is String) {
      gender = json["gender"];
    }
    if(json["address"] is String) {
      address = json["address"];
    }
    if(json["bio"] is String) {
      bio = json["bio"];
    }
    if(json["avatar"] is String) {
      avatar = json["avatar"];
    }
    if(json["company_name"] is String) {
      companyName = json["company_name"];
    }
    if(json["company_type"] is String) {
      companyType = json["company_type"];
    }
    if(json["company_email"] is String) {
      companyEmail = json["company_email"];
    }
    if(json["company_phone"] is String) {
      companyPhone = json["company_phone"];
    }
    if(json["company_gst"] is String) {
      companyGst = json["company_gst"];
    }
    if(json["company_address"] is String) {
      companyAddress = json["company_address"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["email"] = email;
    _data["mobile"] = mobile;
    _data["pan"] = pan;
    _data["date_of_birth"] = dateOfBirth;
    _data["gender"] = gender;
    _data["address"] = address;
    _data["bio"] = bio;
    _data["avatar"] = avatar;
    _data["company_name"] = companyName;
    _data["company_type"] = companyType;
    _data["company_email"] = companyEmail;
    _data["company_phone"] = companyPhone;
    _data["company_gst"] = companyGst;
    _data["company_address"] = companyAddress;
    return _data;
  }
}