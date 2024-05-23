// class EstimateListModel {
//   String? status;
//   String? message;
//   List<EstimateData>? data;

//   EstimateListModel({this.status, this.message, this.data});

//   EstimateListModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <EstimateData>[];
//       json['data'].forEach((v) {
//         data!.add(new EstimateData.fromJson(v));
//       });
//     }
//   }

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

// class EstimateData {
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
//   String? totalServicesAmount;
//   String? couponCode;
//   String? totalDiscount;
//   String? totalTaxableAmount;
//   String? totalApplicableTax;
//   String? totalPayableAmount;
//   int? status;
//   String? currentStatus;
//   String? franchisee;
//   String? modalName;
//   String? createdAt;
//   int? billsStatus;
//   List<SelectServices>? selectServices;
//   List<PpfServices>? ppfServices;

//   EstimateData(
//       {this.id,
//       this.userId,
//       this.name,
//       this.date,
//       this.phone,
//       this.address,
//       this.email,
//       this.vehicleNumber,
//       this.modelId,
//       this.makeId,
//       this.year,
//       this.color,
//       this.vin,
//       this.gst,
//       this.segment,
//       this.estimatedDeliveryTime,
//       this.assignedWorker,
//       this.totalServicesAmount,
//       this.couponCode,
//       this.totalDiscount,
//       this.totalTaxableAmount,
//       this.totalApplicableTax,
//       this.totalPayableAmount,
//       this.status,
//       this.franchisee,
//       this.modalName,
//       this.createdAt,
//       this.billsStatus,
//       this.currentStatus,
//       this.selectServices,
//       this.ppfServices});

//   EstimateData.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     userId = json['user_id'];
//     name = json['name'];
//     date = json['date'];
//     phone = json['phone'];
//     address = json['address'];
//     email = json['email'];
//     vehicleNumber = json['vehicle_number'];
//     modelId = json['model_id'];
//     makeId = json['make_id'];
//     year = json['year'];
//     color = json['color'];
//     vin = json['vin'];
//     gst = json['gst'];
//     segment = json['segment'];
//     createdAt = json['created_date'];
//     billsStatus = json['bill_status'];
//     estimatedDeliveryTime = json['estimated_delivery_time'];
//     assignedWorker = json['assigned_worker'];
//     totalServicesAmount = json['total_services_amount'];
//     couponCode = json['coupon_code'];
//     totalDiscount = json['total_discount'];
//     totalTaxableAmount = json['total_taxable_amount'];
//     totalApplicableTax = json['total_applicable_tax'];
//     totalPayableAmount = json['total_payable_amount'];
//     status = json['status'];
//     currentStatus = json['current_status'];
//     franchisee = json['franchisee'];
//     modalName = json['modal_name'];
//     if (json['select_services'] != null) {
//       selectServices = <SelectServices>[];
//       json['select_services'].forEach((v) {
//         selectServices!.add(new SelectServices.fromJson(v));
//       });
//     }
//     if (json['ppf_services'] != null) {
//       ppfServices = <PpfServices>[];
//       json['ppf_services'].forEach((v) {
//         ppfServices!.add(new PpfServices.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['user_id'] = this.userId;
//     data['name'] = this.name;
//     data['date'] = this.date;
//     data['phone'] = this.phone;
//     data['address'] = this.address;
//     data['email'] = this.email;
//     data['vehicle_number'] = this.vehicleNumber;
//     data['model_id'] = this.modelId;
//     data['make_id'] = this.makeId;
//     data['year'] = this.year;
//     data['color'] = this.color;
//     data['vin'] = this.vin;
//     data['gst'] = this.gst;
//     data['segment'] = this.segment;
//     data['created_date'] = this.createdAt;
//     data['estimated_delivery_time'] = this.estimatedDeliveryTime;
//     data['assigned_worker'] = this.assignedWorker;
//     data['total_services_amount'] = this.totalServicesAmount;
//     data['coupon_code'] = this.couponCode;
//     data['total_discount'] = this.totalDiscount;
//     data['total_taxable_amount'] = this.totalTaxableAmount;
//     data['total_applicable_tax'] = this.totalApplicableTax;
//     data['total_payable_amount'] = this.totalPayableAmount;
//     data['status'] = this.status;
//     data['bill_status'] = this.billsStatus;
//     data['franchisee'] = this.franchisee;
//     data['modal_name'] = this.modalName;
//     data['current_status'] = this.currentStatus;
//     if (this.selectServices != null) {
//       data['select_services'] = this.selectServices!.map((v) => v.toJson()).toList();
//     }
//     if (this.ppfServices != null) {
//       data['ppf_services'] = this.ppfServices!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class SelectServices {
//   String? name;
//   String? type;
//   String? package;
//   String? amount;

//   SelectServices({this.name, this.type, this.package, this.amount});

//   SelectServices.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     type = json['type'];
//     package = json['package'];
//     amount = json['amount'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['type'] = this.type;
//     data['package'] = this.package;
//     data['amount'] = this.amount;
//     return data;
//   }
// }

// class PpfServices {
//   String? name;
//   String? type;
//   String? package;
//   String? amount;

//   PpfServices({this.name, this.type, this.package, this.amount});

//   PpfServices.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     type = json['type'];
//     package = json['package'];
//     amount = json['amount'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['type'] = this.type;
//     data['package'] = this.package;
//     data['amount'] = this.amount;
//     return data;
//   }
// }

class EstimateListModel {
  String? status;
  String? message;
  List<EstimateData>? data;

  EstimateListModel({this.status, this.message, this.data});

  EstimateListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EstimateData>[];
      json['data'].forEach((v) {
        data!.add(new EstimateData.fromJson(v));
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

class EstimateData {
  int? id;
  int? userId;
  String? name;
  String? date;
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
  String? assignedWorker;
  String? totalServicesAmount;
  String? couponCode;
  String? totalDiscount;
  String? totalTaxableAmount;
  String? totalApplicableTax;
  String? totalPayableAmount;
  int? status;
  String? currentStatus;
  int? billsStatus;
  String? franchisee;
  String? modalName;
  List<SelectServices>? selectServices;
  List<PpfServices>? ppfServices;
  List<int>? ppfServicesAmountList;

  EstimateData(
      {this.id,
      this.userId,
      this.name,
      this.date,
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
      this.assignedWorker,
      this.totalServicesAmount,
      this.couponCode,
      this.totalDiscount,
      this.totalTaxableAmount,
      this.totalApplicableTax,
      this.totalPayableAmount,
      this.status,
      this.currentStatus,
      this.billsStatus,
      this.franchisee,
      this.modalName,
      this.selectServices,
      this.ppfServices,
        this.ppfServicesAmountList
      });

  EstimateData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
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
    assignedWorker = json['assigned_worker'];
    totalServicesAmount = json['total_services_amount'];
    couponCode = json['coupon_code'];
    totalDiscount = json['total_discount'];
    totalTaxableAmount = json['total_taxable_amount'];
    totalApplicableTax = json['total_applicable_tax'];
    totalPayableAmount = json['total_payable_amount'];
    status = json['status'];
    currentStatus = json['current_status'];
    billsStatus = json['bills_status'];
    franchisee = json['franchisee'];
    modalName = json['modal_name'];
    if (json['select_services'] != null) {
      selectServices = <SelectServices>[];
      json['select_services'].forEach((v) {
        selectServices!.add(new SelectServices.fromJson(v));
      });
    }
    if (json['ppf_services'] != null) {
      ppfServices = <PpfServices>[];
      json['ppf_services'].forEach((v) {
        ppfServices!.add(new PpfServices.fromJson(v));
      });
    }
    if (json['ppf_services_amountlist'] != null) {
      ppfServicesAmountList = List<int>.from(json['ppf_services_amountlist'].map((x) => int.parse(x.toString())));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
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
    data['assigned_worker'] = this.assignedWorker;
    data['total_services_amount'] = this.totalServicesAmount;
    data['coupon_code'] = this.couponCode;
    data['total_discount'] = this.totalDiscount;
    data['total_taxable_amount'] = this.totalTaxableAmount;
    data['total_applicable_tax'] = this.totalApplicableTax;
    data['total_payable_amount'] = this.totalPayableAmount;
    data['status'] = this.status;
    data['current_status'] = this.currentStatus;
    data['bills_status'] = this.billsStatus;
    data['franchisee'] = this.franchisee;
    data['modal_name'] = this.modalName;
    if (this.selectServices != null) {
      data['select_services'] = this.selectServices!.map((v) => v.toJson()).toList();
    }
    if (this.ppfServices != null) {
      data['ppf_services'] = this.ppfServices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SelectServices {
  String? name;
  String? type;
  String? package;
  String? amount;

  SelectServices({this.name, this.type, this.package, this.amount});

  SelectServices.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    package = json['package'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['package'] = this.package;
    data['amount'] = this.amount;
    return data;
  }
}

class PpfServices {
  String? name;
  String? type;
  String? package;
  String? amount;
  List? services;

  PpfServices({
    this.name,
    this.type,
    this.package,
    this.amount,
    this.services,
  });

  PpfServices.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    package = json['package'];
    amount = json['amount'];
    services = json['services'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['package'] = this.package;
    data['amount'] = this.amount;
    data['services'] = this.services;
    return data;
  }
}
