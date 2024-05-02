class GetServicesModal {
  int? status;
  String? message;
  List<Services>? services;

  GetServicesModal({this.status, this.message, this.services});

  GetServicesModal.fromJson(Map<String, dynamic> json) {
    if (json["status"] is int) {
      status = json["status"];
    }
    if (json["message"] is String) {
      message = json["message"];
    }
    if (json["services"] is List) {
      services = json["services"] == null ? null : (json["services"] as List).map((e) => Services.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["message"] = message;
    if (services != null) {
      _data["services"] = services?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Services {
  int? id;
  String? name;

  Services({this.id, this.name});

  Services.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    return _data;
  }
}




// class EstimateListModel {
//   String? status;
//   String? message;
//   Data? data;
//   int? currentPage;
//   int? totalPage;

//   EstimateListModel({this.status, this.message, this.data, this.currentPage, this.totalPage});

//   EstimateListModel.fromJson(Map<String, dynamic> json) {
//     if (json["status"] is String) {
//       status = json["status"];
//     }
//     if (json["message"] is String) {
//       message = json["message"];
//     }
//     if (json["data"] is Map) {
//       data = json["data"] == null ? null : Data.fromJson(json["data"]);
//     }
//     if (json["current_page"] is int) {
//       currentPage = json["current_page"];
//     }
//     if (json["total_page"] is int) {
//       totalPage = json["total_page"];
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> _data = <String, dynamic>{};
//     _data["status"] = status;
//     _data["message"] = message;
//     if (data != null) {
//       _data["data"] = data?.toJson();
//     }
//     _data["current_page"] = currentPage;
//     _data["total_page"] = totalPage;
//     return _data;
//   }
// }

// class Data {
//   int? currentPage;
//   List<Data1>? data;
//   String? firstPageUrl;
//   int? from;
//   int? lastPage;
//   String? lastPageUrl;
//   List<Links>? links;
//   dynamic nextPageUrl;
//   String? path;
//   int? perPage;
//   dynamic prevPageUrl;
//   int? to;
//   int? total;

//   Data(
//       {this.currentPage,
//       this.data,
//       this.firstPageUrl,
//       this.from,
//       this.lastPage,
//       this.lastPageUrl,
//       this.links,
//       this.nextPageUrl,
//       this.path,
//       this.perPage,
//       this.prevPageUrl,
//       this.to,
//       this.total});

//   Data.fromJson(Map<String, dynamic> json) {
//     if (json["current_page"] is int) {
//       currentPage = json["current_page"];
//     }
//     if (json["data"] is List) {
//       data = json["data"] == null ? null : (json["data"] as List).map((e) => Data1.fromJson(e)).toList();
//     }
//     if (json["first_page_url"] is String) {
//       firstPageUrl = json["first_page_url"];
//     }
//     if (json["from"] is int) {
//       from = json["from"];
//     }
//     if (json["last_page"] is int) {
//       lastPage = json["last_page"];
//     }
//     if (json["last_page_url"] is String) {
//       lastPageUrl = json["last_page_url"];
//     }
//     if (json["links"] is List) {
//       links = json["links"] == null ? null : (json["links"] as List).map((e) => Links.fromJson(e)).toList();
//     }
//     nextPageUrl = json["next_page_url"];
//     if (json["path"] is String) {
//       path = json["path"];
//     }
//     if (json["per_page"] is int) {
//       perPage = json["per_page"];
//     }
//     prevPageUrl = json["prev_page_url"];
//     if (json["to"] is int) {
//       to = json["to"];
//     }
//     if (json["total"] is int) {
//       total = json["total"];
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> _data = <String, dynamic>{};
//     _data["current_page"] = currentPage;
//     if (data != null) {
//       _data["data"] = data?.map((e) => e.toJson()).toList();
//     }
//     _data["first_page_url"] = firstPageUrl;
//     _data["from"] = from;
//     _data["last_page"] = lastPage;
//     _data["last_page_url"] = lastPageUrl;
//     if (links != null) {
//       _data["links"] = links?.map((e) => e.toJson()).toList();
//     }
//     _data["next_page_url"] = nextPageUrl;
//     _data["path"] = path;
//     _data["per_page"] = perPage;
//     _data["prev_page_url"] = prevPageUrl;
//     _data["to"] = to;
//     _data["total"] = total;
//     return _data;
//   }
// }

// class Links {
//   dynamic url;
//   String? label;
//   bool? active;

//   Links({this.url, this.label, this.active});

//   Links.fromJson(Map<String, dynamic> json) {
//     url = json["url"];
//     if (json["label"] is String) {
//       label = json["label"];
//     }
//     if (json["active"] is bool) {
//       active = json["active"];
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> _data = <String, dynamic>{};
//     _data["url"] = url;
//     _data["label"] = label;
//     _data["active"] = active;
//     return _data;
//   }
// }

// class Data1 {
//   int? id;
//   int? userId;
//   String? name;
//   String? date;
//   String? phone;
//   String? address;
//   String? email;
//   String? vehicleNumber;
//   String? modelId;
//   String? makeId;
//   String? year;
//   String? color;
//   String? vin;
//   String? gst;
//   String? segment;
//   String? currentStatus;
//   String? estimatedDeliveryTime;
//   String? assignedWorker;
//   int? status;
//   String? createdAt;
//   String? updatedAt;
//   String? franchisee;
//   String? modalName;
//   String? selectServicesName;
//   String? selectServicesType;
//   String? selectServicesPackage;
//   String? selectServicesAmount;
//   List<String>? servicesSelected;
//   String? ppfServicesName;
//   String? ppfServicesType;
//   String? ppfServicesPackage;
//   String? ppfServicesAmount;
//   List<String>? ppfServicesSelected;

//   Data1(
//       {this.id,
//       this.userId,
//       this.name,
//       this.date,
//       this.phone,
//       this.address,
//       this.email,
//       this.vehicleNumber,
//       this.modelId,
//       this.currentStatus,
//       this.makeId,
//       this.year,
//       this.color,
//       this.vin,
//       this.gst,
//       this.segment,
//       this.estimatedDeliveryTime,
//       this.assignedWorker,
//       this.status,
//       this.createdAt,
//       this.updatedAt,
//       this.franchisee,
//       this.modalName,
//       this.selectServicesName,
//       this.selectServicesType,
//       this.selectServicesPackage,
//       this.selectServicesAmount,
//       this.servicesSelected,
//       this.ppfServicesName,
//       this.ppfServicesType,
//       this.ppfServicesPackage,
//       this.ppfServicesAmount,
//       this.ppfServicesSelected});

//   Data1.fromJson(Map<String, dynamic> json) {
//     if (json["id"] is int) {
//       id = json["id"];
//     }
//     if (json["user_id"] is int) {
//       userId = json["user_id"];
//     }
//     if (json["name"] is String) {
//       name = json["name"];
//     }
//     if (json["date"] is String) {
//       date = json["date"];
//     }
//     if (json["phone"] is String) {
//       phone = json["phone"];
//     }
//     if (json["address"] is String) {
//       address = json["address"];
//     }
//     if (json["email"] is String) {
//       email = json["email"];
//     }
//     if (json["vehicle_number"] is String) {
//       vehicleNumber = json["vehicle_number"];
//     }
//     if (json["model_id"] is String) {
//       modelId = json["model_id"];
//     }
//     if (json["make_id"] is String) {
//       makeId = json["make_id"];
//     }
//     if (json["year"] is String) {
//       year = json["year"];
//     }
//     if (json["color"] is String) {
//       color = json["color"];
//     }
//     if (json["vin"] is String) {
//       vin = json["vin"];
//     }
//     if (json["gst"] is String) {
//       gst = json["gst"];
//     }
//     if (json["segment"] is String) {
//       segment = json["segment"];
//     }
//     if (json["estimated_delivery_time"] is String) {
//       estimatedDeliveryTime = json["estimated_delivery_time"];
//     }
//     if (json["assigned_worker"] is String) {
//       assignedWorker = json["assigned_worker"];
//     }
//     if (json["status"] is int) {
//       status = json["status"];
//     }
//     if (json["created_at"] is String) {
//       createdAt = json["created_at"];
//     }
//     if (json["updated_at"] is String) {
//       updatedAt = json["updated_at"];
//     }
//     if (json["franchisee"] is String) {
//       franchisee = json["franchisee"];
//     }
//     if (json["modal_name"] is String) {
//       modalName = json["modal_name"];
//     }
//     if (json["select_services_name"] is String) {
//       selectServicesName = json["select_services_name"];
//     }
//     if (json["select_services_type"] is String) {
//       selectServicesType = json["select_services_type"];
//     }
//     if (json["select_services_package"] is String) {
//       selectServicesPackage = json["select_services_package"];
//     }
//     if (json["select_services_amount"] is String) {
//       selectServicesAmount = json["select_services_amount"];
//     }

//     servicesSelected = json['services_selected'] != null ? List<String>.from(jsonDecode(json['services_selected'])) : [];

//     if (json["ppf_services_name"] is String) {
//       ppfServicesName = json["ppf_services_name"];
//     }
//     if (json["ppf_services_type"] is String) {
//       ppfServicesType = json["ppf_services_type"];
//     }
//     if (json["ppf_services_package"] is String) {
//       ppfServicesPackage = json["ppf_services_package"];
//     }
//     if (json["ppf_services_amount"] is String) {
//       ppfServicesAmount = json["ppf_services_amount"];
//     }
//     if (json["current_status"] is String) {
//       currentStatus = json["current_status"];
//     }
//     ppfServicesSelected = json['ppf_services_selected'] != null && json['ppf_services_selected'] != "[]" ? List<String>.from(jsonDecode(json['ppf_services_selected'])) : [];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> _data = <String, dynamic>{};
//     _data["id"] = id;
//     _data["user_id"] = userId;
//     _data["name"] = name;
//     _data["date"] = date;
//     _data["phone"] = phone;
//     _data["address"] = address;
//     _data["email"] = email;
//     _data["vehicle_number"] = vehicleNumber;
//     _data["model_id"] = modelId;
//     _data["make_id"] = makeId;
//     _data["year"] = year;
//     _data["color"] = color;
//     _data["vin"] = vin;
//     _data["gst"] = gst;
//     _data["segment"] = segment;
//     _data["estimated_delivery_time"] = estimatedDeliveryTime;
//     _data["assigned_worker"] = assignedWorker;
//     _data["status"] = status;
//     _data["created_at"] = createdAt;
//     _data["updated_at"] = updatedAt;
//     _data["franchisee"] = franchisee;
//     _data["modal_name"] = modalName;
//     _data["select_services_name"] = selectServicesName;
//     _data["select_services_type"] = selectServicesType;
//     _data["select_services_package"] = selectServicesPackage;
//     _data["select_services_amount"] = selectServicesAmount;
//     _data["services_selected"] = servicesSelected;
//     _data["ppf_services_name"] = ppfServicesName;
//     _data["ppf_services_type"] = ppfServicesType;
//     _data["ppf_services_package"] = ppfServicesPackage;
//     _data["ppf_services_amount"] = ppfServicesAmount;
//     _data["ppf_services_selected"] = ppfServicesSelected;
//     _data["current_status"] = currentStatus;
//     return _data;
//   }
// }
