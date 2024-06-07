
class QuatationModel {
  String? status;
  String? message;
  List<QuotationData>? data;

  QuatationModel({this.status, this.message, this.data});

  QuatationModel.fromJson(Map<String, dynamic> json) {
    if (json["status"] is String) {
      status = json["status"];
    }
    if (json["message"] is String) {
      message = json["message"];
    }
    if (json["data"] is List) {
      data = json["data"] == null ? null : (json["data"] as List).map((e) => QuotationData.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["message"] = message;
    if (data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class QuotationData {
  int? id;
  int? userId;
  String? vehicleNumber;
  String? model;
  String? makeId;
  String? date;
  int? mobile;
  String? deliveryDate;
  String? advance;
  String? segment;
  List<String>? services;
  int? status;
  String? createdBy;
  String? updatedBy;
  String? franchisee;

  QuotationData(
      {this.id,
        this.userId,
        this.vehicleNumber,
        this.model,
        this.makeId,
        this.date,
        this.mobile,
        this.deliveryDate,
        this.advance,
        this.segment,
        this.services,
        this.status,
        this.createdBy,
        this.updatedBy,
        this.franchisee});

  QuotationData.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["user_id"] is int) {
      userId = json["user_id"];
    }
    if (json["vehicle_number"] is String) {
      vehicleNumber = json["vehicle_number"];
    }
    if (json["model"] is String) {
      model = json["model"];
    }
    if (json["make_id"] is String) {
      makeId = json["make_id"];
    }
    if (json["date"] is String) {
      date = json["date"];
    }
    if (json["mobile"] is int) {
      mobile = json["mobile"];
    }
    if (json["delivery_date"] is String) {
      deliveryDate = json["delivery_date"];
    }
    if (json["advance"] is String) {
      advance = json["advance"];
    }
    if (json["segment"] is String) {
      segment = json["segment"];
    }
    if (json["services"] is List) {
      services = json["services"] == null ? null : List<String>.from(json["services"]);
    }
    if (json["status"] is int) {
      status = json["status"];
    }
    if (json["created_by"] is String) {
      createdBy = json["created_by"];
    }
    if (json["updated_by"] is String) {
      updatedBy = json["updated_by"];
    }
    if (json["franchisee"] is String) {
      franchisee = json["franchisee"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["user_id"] = userId;
    _data["vehicle_number"] = vehicleNumber;
    _data["model"] = model;
    _data["make_id"] = makeId;
    _data["date"] = date;
    _data["mobile"] = mobile;
    _data["delivery_date"] = deliveryDate;
    _data["advance"] = advance;
    _data["segment"] = segment;
    if (services != null) {
      _data["services"] = services;
    }
    _data["status"] = status;
    _data["created_by"] = createdBy;
    _data["updated_by"] = updatedBy;
    _data["franchisee"] = franchisee;
    return _data;
  }
}



// class QuatationModel {
//   String? status;
//   String? message;
//   List<QuotationData>? data;
//
//   QuatationModel({this.status, this.message, this.data});
//
//   QuatationModel.fromJson(Map<String, dynamic> json) {
//     if (json["status"] is String) {
//       status = json["status"];
//     }
//     if (json["message"] is String) {
//       message = json["message"];
//     }
//     if (json["data"] is List) {
//       data = json["data"] == null ? null : (json["data"] as List).map((e) => QuotationData.fromJson(e)).toList();
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> _data = <String, dynamic>{};
//     _data["status"] = status;
//     _data["message"] = message;
//     if (data != null) {
//       _data["data"] = data?.map((e) => e.toJson()).toList();
//     }
//     return _data;
//   }
// }
//
// class QuotationData {
//   int? id;
//   int? userId;
//   String? vehicleNumber;
//   String? model;
//   String? makeId;
//   String? date;
//   int? mobile;
//   String? deliveryDate;
//   String? advance;
//   String? segment;
//   String? services;
//   int? status;
//   String? createdBy;
//   String? updatedBy;
//   String? franchisee;
//
//   QuotationData(
//       {this.id,
//       this.userId,
//       this.vehicleNumber,
//       this.model,
//       this.makeId,
//       this.date,
//       this.mobile,
//       this.deliveryDate,
//       this.advance,
//       this.segment,
//       this.services,
//       this.status,
//       this.createdBy,
//       this.updatedBy,
//       this.franchisee});
//
//   QuotationData.fromJson(Map<String, dynamic> json) {
//     if (json["id"] is int) {
//       id = json["id"];
//     }
//     if (json["user_id"] is int) {
//       userId = json["user_id"];
//     }
//     if (json["vehicle_number"] is String) {
//       vehicleNumber = json["vehicle_number"];
//     }
//     if (json["model"] is String) {
//       model = json["model"];
//     }
//     if (json["make_id"] is String) {
//       makeId = json["make_id"];
//     }
//     if (json["date"] is String) {
//       date = json["date"];
//     }
//     if (json["mobile"] is int) {
//       mobile = json["mobile"];
//     }
//     if (json["delivery_date"] is String) {
//       deliveryDate = json["delivery_date"];
//     }
//     if (json["advance"] is String) {
//       advance = json["advance"];
//     }
//     if (json["segment"] is String) {
//       segment = json["segment"];
//     }
//     if (json["services"] is String) {
//       services = json["services"];
//     }
//     if (json["status"] is int) {
//       status = json["status"];
//     }
//     if (json["created_by"] is String) {
//       createdBy = json["created_by"];
//     }
//     if (json["updated_by"] is String) {
//       updatedBy = json["updated_by"];
//     }
//     if (json["franchisee"] is String) {
//       franchisee = json["franchisee"];
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> _data = <String, dynamic>{};
//     _data["id"] = id;
//     _data["user_id"] = userId;
//     _data["vehicle_number"] = vehicleNumber;
//     _data["model"] = model;
//     _data["make_id"] = makeId;
//     _data["date"] = date;
//     _data["mobile"] = mobile;
//     _data["delivery_date"] = deliveryDate;
//     _data["advance"] = advance;
//     _data["segment"] = segment;
//     _data["services"] = services;
//     _data["status"] = status;
//     _data["created_by"] = createdBy;
//     _data["updated_by"] = updatedBy;
//     _data["franchisee"] = franchisee;
//     return _data;
//   }
// }


// class QuatationModel {
//   String? status;
//   String? message;
//   List<Data>? data;
//
//   QuatationModel({this.status, this.message, this.data});
//
//   QuatationModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   int? id;
//   String? vehicleNumber;
//   String? model;
//   String? makeId;
//   String? date;
//   int? mobile;
//   String? deliveryDate;
//   String? advance;
//   String? segment;
//   List<String>? services;
//
//   Data(
//       {this.id,
//         this.vehicleNumber,
//         this.model,
//         this.makeId,
//         this.date,
//         this.mobile,
//         this.deliveryDate,
//         this.advance,
//         this.segment,
//         this.services});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     vehicleNumber = json['vehicle_number'];
//     model = json['model'];
//     makeId = json['make_id'];
//     date = json['date'];
//     mobile = json['mobile'];
//     deliveryDate = json['delivery_date'];
//     advance = json['advance'];
//     segment = json['segment'];
//     services = json['services'].cast<String>();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['vehicle_number'] = this.vehicleNumber;
//     data['model'] = this.model;
//     data['make_id'] = this.makeId;
//     data['date'] = this.date;
//     data['mobile'] = this.mobile;
//     data['delivery_date'] = this.deliveryDate;
//     data['advance'] = this.advance;
//     data['segment'] = this.segment;
//     data['services'] = this.services;
//     return data;
//   }
// }
