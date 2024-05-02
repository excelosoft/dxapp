
class CouponCodeModal {
  int? status;
  String? message;
  List<Coupons>? coupons;

  CouponCodeModal({this.status, this.message, this.coupons});

  CouponCodeModal.fromJson(Map<String, dynamic> json) {
    if(json["status"] is int) {
      status = json["status"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["coupons"] is List) {
      coupons = json["coupons"] == null ? null : (json["coupons"] as List).map((e) => Coupons.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["message"] = message;
    if(coupons != null) {
      _data["coupons"] = coupons?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Coupons {
  int? id;
  String? code;
  String? name;
  String? description;
  int? discount;

  Coupons({this.id, this.code, this.name, this.description, this.discount});

  Coupons.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["code"] is String) {
      code = json["code"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["description"] is String) {
      description = json["description"];
    }
    if(json["discount"] is int) {
      discount = json["discount"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["code"] = code;
    _data["name"] = name;
    _data["description"] = description;
    _data["discount"] = discount;
    return _data;
  }
}