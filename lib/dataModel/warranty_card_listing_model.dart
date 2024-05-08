class WarrantyCardListingModel {
  String? status;
  String? message;
  List<WarrantyData>? data;

  WarrantyCardListingModel({this.status, this.message, this.data});

  WarrantyCardListingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <WarrantyData>[];
      json['data'].forEach((v) {
        data!.add(WarrantyData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WarrantyData {
  int? id;
  int? userId;
  String? maintenanceNumber;
  String? name;
  String? date;
  List? dueDate;
  String? phone;
  String? address;
  String? email;
  String? vehicleNumber;
  String? modelId;
  String? makeId;
  String? year;
  String? color;
  String? vin;
  String? gst;
  String? segment;
  String? estimatedDeliveryTime;
  String? hsnNo;
  String? assignedWorker;
  String? totalServicesAmount;
  String? couponCode;
  String? totalDiscount;
  String? totalTaxableAmount;
  String? totalApplicableTax;
  String? totalPayableAmount;
  int? status;
  int? jobsheetStatus;
  String? carphoto;
  String? remarks;
  int? billsStatus;
  int? warrantyStatus;
  int? maintenanceStatus;
  String? currentStatus;
  String? createdAt;
  String? updatedAt;
  String? franchisee;
  String? modalName;
  String? selectServicesName;
  String? selectServicesType;
  String? selectServicesPackage;
  String? selectServicesAmount;
  String? servicesSelected;
  String? ssServicesWarrantyYears;
  String? ppfServicesName;
  String? ppfServicesType;
  String? ppfServicesPackage;
  String? ppfServicesAmount;
  String? ppfServicesSelected;
  String? ppfServicesWarrantyYears;

  WarrantyData(
      {this.id,
      this.userId,
      this.maintenanceNumber,
      this.name,
      this.date,
      this.dueDate,
      this.phone,
      this.address,
      this.email,
      this.vehicleNumber,
      this.modelId,
      this.makeId,
      this.year,
      this.color,
      this.vin,
      this.gst,
      this.segment,
      this.estimatedDeliveryTime,
      this.hsnNo,
      this.assignedWorker,
      this.totalServicesAmount,
      this.couponCode,
      this.totalDiscount,
      this.totalTaxableAmount,
      this.totalApplicableTax,
      this.totalPayableAmount,
      this.status,
      this.jobsheetStatus,
      this.carphoto,
      this.remarks,
      this.billsStatus,
      this.warrantyStatus,
      this.maintenanceStatus,
      this.currentStatus,
      this.createdAt,
      this.updatedAt,
      this.franchisee,
      this.modalName,
      this.selectServicesName,
      this.selectServicesType,
      this.selectServicesPackage,
      this.selectServicesAmount,
      this.servicesSelected,
      this.ssServicesWarrantyYears,
      this.ppfServicesName,
      this.ppfServicesType,
      this.ppfServicesPackage,
      this.ppfServicesAmount,
      this.ppfServicesSelected,
      this.ppfServicesWarrantyYears});

  WarrantyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    userId = json['maintenanceNumber'];
    name = json['name'];
    dueDate = json['due_date'];
    date = json['date'];
    phone = json['phone'];
    address = json['address'];
    email = json['email'];
    vehicleNumber = json['vehicle_number'];
    modelId = json['model_id'];
    makeId = json['make_id'];
    year = json['year'];
    color = json['color'];
    vin = json['vin'];
    gst = json['gst'];
    segment = json['segment'];
    estimatedDeliveryTime = json['estimated_delivery_time'];
    hsnNo = json['hsn_no'];
    assignedWorker = json['assigned_worker'];
    totalServicesAmount = json['total_services_amount'];
    couponCode = json['coupon_code'];
    totalDiscount = json['total_discount'];
    totalTaxableAmount = json['total_taxable_amount'];
    totalApplicableTax = json['total_applicable_tax'];
    totalPayableAmount = json['total_payable_amount'];
    status = json['status'];
    jobsheetStatus = json['jobsheet_status'];
    carphoto = json['carphoto'];
    remarks = json['remarks'];
    billsStatus = json['bills_status'];
    warrantyStatus = json['warranty_status'];
    maintenanceStatus = json['maintenance_status'];
    currentStatus = json['current_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    franchisee = json['franchisee'];
    modalName = json['modal_name'];
    selectServicesName = json['select_services_name'];
    selectServicesType = json['select_services_type'];
    selectServicesPackage = json['select_services_package'];
    selectServicesAmount = json['select_services_amount'];
    servicesSelected = json['services_selected'];
    ssServicesWarrantyYears = json['ss_services_warranty_years'];
    ppfServicesName = json['ppf_services_name'];
    ppfServicesType = json['ppf_services_type'];
    ppfServicesPackage = json['ppf_services_package'];
    ppfServicesAmount = json['ppf_services_amount'];
    ppfServicesSelected = json['ppf_services_selected'];
    ppfServicesWarrantyYears = json['ppf_services_warranty_years'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['maintenance_number'] = this.maintenanceNumber;
    data['due_date'] = this.dueDate;
    data['name'] = this.name;
    data['date'] = this.date;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['email'] = this.email;
    data['vehicle_number'] = this.vehicleNumber;
    data['model_id'] = this.modelId;
    data['make_id'] = this.makeId;
    data['year'] = this.year;
    data['color'] = this.color;
    data['vin'] = this.vin;
    data['gst'] = this.gst;
    data['segment'] = this.segment;
    data['estimated_delivery_time'] = this.estimatedDeliveryTime;
    data['hsn_no'] = this.hsnNo;
    data['assigned_worker'] = this.assignedWorker;
    data['total_services_amount'] = this.totalServicesAmount;
    data['coupon_code'] = this.couponCode;
    data['total_discount'] = this.totalDiscount;
    data['total_taxable_amount'] = this.totalTaxableAmount;
    data['total_applicable_tax'] = this.totalApplicableTax;
    data['total_payable_amount'] = this.totalPayableAmount;
    data['status'] = this.status;
    data['jobsheet_status'] = this.jobsheetStatus;
    data['carphoto'] = this.carphoto;
    data['remarks'] = this.remarks;
    data['bills_status'] = this.billsStatus;
    data['warranty_status'] = this.warrantyStatus;
    data['maintenance_status'] = this.maintenanceStatus;
    data['current_status'] = this.currentStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['franchisee'] = this.franchisee;
    data['modal_name'] = this.modalName;
    data['select_services_name'] = this.selectServicesName;
    data['select_services_type'] = this.selectServicesType;
    data['select_services_package'] = this.selectServicesPackage;
    data['select_services_amount'] = this.selectServicesAmount;
    data['services_selected'] = this.servicesSelected;
    data['ss_services_warranty_years'] = this.ssServicesWarrantyYears;
    data['ppf_services_name'] = this.ppfServicesName;
    data['ppf_services_type'] = this.ppfServicesType;
    data['ppf_services_package'] = this.ppfServicesPackage;
    data['ppf_services_amount'] = this.ppfServicesAmount;
    data['ppf_services_selected'] = this.ppfServicesSelected;
    data['ppf_services_warranty_years'] = this.ppfServicesWarrantyYears;
    return data;
  }
}



// class WarrantyCardListingModel {
//   String? status;
//   String? message;
//   Data? data;
//   int? currentPage;
//   int? totalPage;

//   WarrantyCardListingModel({this.status, this.message, this.data, this.currentPage, this.totalPage});

//   WarrantyCardListingModel.fromJson(Map<String, dynamic> json) {
//     if(json["status"] is String) {
//       status = json["status"];
//     }
//     if(json["message"] is String) {
//       message = json["message"];
//     }
//     if(json["data"] is Map) {
//       data = json["data"] == null ? null : Data.fromJson(json["data"]);
//     }
//     if(json["current_page"] is int) {
//       currentPage = json["current_page"];
//     }
//     if(json["total_page"] is int) {
//       totalPage = json["total_page"];
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> _data = <String, dynamic>{};
//     _data["status"] = status;
//     _data["message"] = message;
//     if(data != null) {
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

//   Data({this.currentPage, this.data, this.firstPageUrl, this.from, this.lastPage, this.lastPageUrl, this.links, this.nextPageUrl, this.path, this.perPage, this.prevPageUrl, this.to, this.total});

//   Data.fromJson(Map<String, dynamic> json) {
//     if(json["current_page"] is int) {
//       currentPage = json["current_page"];
//     }
//     if(json["data"] is List) {
//       data = json["data"] == null ? null : (json["data"] as List).map((e) => Data1.fromJson(e)).toList();
//     }
//     if(json["first_page_url"] is String) {
//       firstPageUrl = json["first_page_url"];
//     }
//     if(json["from"] is int) {
//       from = json["from"];
//     }
//     if(json["last_page"] is int) {
//       lastPage = json["last_page"];
//     }
//     if(json["last_page_url"] is String) {
//       lastPageUrl = json["last_page_url"];
//     }
//     if(json["links"] is List) {
//       links = json["links"] == null ? null : (json["links"] as List).map((e) => Links.fromJson(e)).toList();
//     }
//     nextPageUrl = json["next_page_url"];
//     if(json["path"] is String) {
//       path = json["path"];
//     }
//     if(json["per_page"] is int) {
//       perPage = json["per_page"];
//     }
//     prevPageUrl = json["prev_page_url"];
//     if(json["to"] is int) {
//       to = json["to"];
//     }
//     if(json["total"] is int) {
//       total = json["total"];
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> _data = <String, dynamic>{};
//     _data["current_page"] = currentPage;
//     if(data != null) {
//       _data["data"] = data?.map((e) => e.toJson()).toList();
//     }
//     _data["first_page_url"] = firstPageUrl;
//     _data["from"] = from;
//     _data["last_page"] = lastPage;
//     _data["last_page_url"] = lastPageUrl;
//     if(links != null) {
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
//     if(json["label"] is String) {
//       label = json["label"];
//     }
//     if(json["active"] is bool) {
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
//   String? estimatedDeliveryTime;
//   String? assignedWorker;
//   String? servicesName;
//   String? servicesType;
//   String? servicesPackage;
//   dynamic servicesData;
//   int? status;
//   String? createdAt;
//   String? updatedAt;
//   String? franchisee;
//   dynamic modalName;

//   Data1({this.id, this.userId, this.name, this.date, this.phone, this.address, this.email, this.vehicleNumber, this.modelId, this.makeId, this.year, this.color, this.vin, this.gst, this.segment, this.estimatedDeliveryTime, this.assignedWorker, this.servicesName, this.servicesType, this.servicesPackage, this.servicesData, this.status, this.createdAt, this.updatedAt, this.franchisee, this.modalName});

//   Data1.fromJson(Map<String, dynamic> json) {
//     if(json["id"] is int) {
//       id = json["id"];
//     }
//     if(json["user_id"] is int) {
//       userId = json["user_id"];
//     }
//     if(json["name"] is String) {
//       name = json["name"];
//     }
//     if(json["date"] is String) {
//       date = json["date"];
//     }
//     if(json["phone"] is String) {
//       phone = json["phone"];
//     }
//     if(json["address"] is String) {
//       address = json["address"];
//     }
//     if(json["email"] is String) {
//       email = json["email"];
//     }
//     if(json["vehicle_number"] is String) {
//       vehicleNumber = json["vehicle_number"];
//     }
//     if(json["model_id"] is String) {
//       modelId = json["model_id"];
//     }
//     if(json["make_id"] is String) {
//       makeId = json["make_id"];
//     }
//     if(json["year"] is String) {
//       year = json["year"];
//     }
//     if(json["color"] is String) {
//       color = json["color"];
//     }
//     if(json["vin"] is String) {
//       vin = json["vin"];
//     }
//     if(json["gst"] is String) {
//       gst = json["gst"];
//     }
//     if(json["segment"] is String) {
//       segment = json["segment"];
//     }
//     if(json["estimated_delivery_time"] is String) {
//       estimatedDeliveryTime = json["estimated_delivery_time"];
//     }
//     if(json["assigned_worker"] is String) {
//       assignedWorker = json["assigned_worker"];
//     }
//     if(json["services_name"] is String) {
//       servicesName = json["services_name"];
//     }
//     if(json["services_type"] is String) {
//       servicesType = json["services_type"];
//     }
//     if(json["services_package"] is String) {
//       servicesPackage = json["services_package"];
//     }
//     servicesData = json["services_data"];
//     if(json["status"] is int) {
//       status = json["status"];
//     }
//     if(json["created_at"] is String) {
//       createdAt = json["created_at"];
//     }
//     if(json["updated_at"] is String) {
//       updatedAt = json["updated_at"];
//     }
//     if(json["franchisee"] is String) {
//       franchisee = json["franchisee"];
//     }
//     modalName = json["modal_name"];
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
//     _data["services_name"] = servicesName;
//     _data["services_type"] = servicesType;
//     _data["services_package"] = servicesPackage;
//     _data["services_data"] = servicesData;
//     _data["status"] = status;
//     _data["created_at"] = createdAt;
//     _data["updated_at"] = updatedAt;
//     _data["franchisee"] = franchisee;
//     _data["modal_name"] = modalName;
//     return _data;
//   }
// }


class WarrantyCardListingModel2 {
  String? status;
  String? message;
  List<WarrantyCardData>? data;

  WarrantyCardListingModel2({this.status, this.message, this.data});

  factory WarrantyCardListingModel2.fromJson(Map<String, dynamic> json) {
    return WarrantyCardListingModel2(
      status: json['status'],
      message: json['message'],
      data: List<WarrantyCardData>.from((json['data'] ?? []).map((x) => WarrantyCardData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'status': status,
      'message': message,
      'data': this.data != null ? this.data!.map((x) => x.toJson()).toList() : null,
    };
    return data;
  }
}

class WarrantyCardData {
  int? id;
  String? name;
  String? date;
  String? phone;
  String? email;
  String? address;
  String? vehicleNumber;
  String? modalName;
  String? makeId;
  String? year;
  String? color;
  String? vin;
  String? gst;
  String? segment;
  String? estimatedDeliveryTime;
  String? assignedWorker;
  List<SelectService>? selectServices;
  List<PpfService>? ppfServices;
  String? maintenanceNumber;
  List<String>? dueDate;
  List<String>? doneDate;
  String? charges;

  WarrantyCardData({
    this.id,
    this.name,
    this.date,
    this.phone,
    this.email,
    this.address,
    this.vehicleNumber,
    this.modalName,
    this.makeId,
    this.year,
    this.color,
    this.vin,
    this.gst,
    this.segment,
    this.estimatedDeliveryTime,
    this.assignedWorker,
    this.selectServices,
    this.ppfServices,
    this.maintenanceNumber,
    this.dueDate,
    this.doneDate,
    this.charges,
  });

  factory WarrantyCardData.fromJson(Map<String, dynamic> json) {
    return WarrantyCardData(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      vehicleNumber: json['vehicle_number'],
      modalName: json['modal_name'],
      makeId: json['make_id'],
      year: json['year'],
      color: json['color'],
      vin: json['vin'],
      gst: json['gst'],
      segment: json['segment'],
      estimatedDeliveryTime: json['estimated_delivery_time'],
      assignedWorker: json['assigned_worker'],
      selectServices: List<SelectService>.from((json['select_services'] ?? []).map((x) => SelectService.fromJson(x))),
      ppfServices: List<PpfService>.from((json['ppf_services'] ?? []).map((x) => PpfService.fromJson(x))),
      maintenanceNumber: json['maintenance_number'],
      dueDate: List<String>.from(json['due_date']?.map((x) => x.toString()) ?? []),
      doneDate: List<String>.from(json['done_date']?.map((x) => x.toString()) ?? []),
      charges: json['charges'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'date': date,
      'phone': phone,
      'email': email,
      'address': address,
      'vehicle_number': vehicleNumber,
      'modal_name': modalName,
      'make_id': makeId,
      'year': year,
      'color': color,
      'vin': vin,
      'gst': gst,
      'segment': segment,
      'estimated_delivery_time': estimatedDeliveryTime,
      'assigned_worker': assignedWorker,
      'select_services': selectServices != null ? selectServices!.map((x) => x.toJson()).toList() : null,
      'ppf_services': ppfServices != null ? ppfServices!.map((x) => x.toJson()).toList() : null,
      'maintenance_number': maintenanceNumber,
      'due_date': dueDate,
      'done_date': doneDate,
      'charges': charges,
    };
    return data;
  }
}

class SelectService {
  String? name;
  String? type;
  String? package;
  String? amount;
  String? servicesSelected;

  SelectService({
    this.name,
    this.type,
    this.package,
    this.amount,
    this.servicesSelected,
  });

  factory SelectService.fromJson(Map<String, dynamic> json) {
    return SelectService(
      name: json['name'],
      type: json['type'],
      package: json['package'],
      amount: json['amount'],
      servicesSelected: json['services_selected'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'package': package,
      'amount': amount,
      'services_selected': servicesSelected,
    };
    return data;
  }
}

class PpfService {
  String? name;
  String? type;
  String? package;
  String? amount;
  List<String>? servicesSelected;

  PpfService({
    this.name,
    this.type,
    this.package,
    this.amount,
    this.servicesSelected,
  });

  factory PpfService.fromJson(Map<String, dynamic> json) {
    return PpfService(
      name: json['name'],
      type: json['type'],
      package: json['package'],
      amount: json['amount'],
      servicesSelected: List<String>.from(json['services_selected'].map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'type': type,
      'package': package,
      'amount': amount,
      'services_selected': servicesSelected,
    };
    return data;
  }
}
