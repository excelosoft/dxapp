// class BillsListResponse {
//   String? status;
//   String? message;
//   List<BillListData>? data;

//   BillsListResponse({this.status, this.message, this.data});

//   BillsListResponse.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <BillListData>[];
//       json['data'].forEach((v) {
//         data!.add(BillListData.fromJson(v));
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

// class BillListData {
//   int? id;
//   String? name;
//   String? date;
//   String? modelId;
//   String? phone;
//   String? email;
//   String? address;
//   String? vehicleNumber;
//   String? modalName;
//   String? makeId;
//   String? year;
//   String? color;
//   String? vin;
//   String? assignedWorker;
//   String? gst;
//   String? segment;
//   String? estimatedDeliveryTime;
//   String? hsnNo;
//   String? couponCode;
//   String? totalServicesAmount;
//   String? totalDiscount;
//   String? totalTaxableAmount;
//   String? totalApplicableTax;
//   String? totalPayableAmount;
//   String? selectServicesName;
//   String? selectServicesAmount;
//   String? selectServicesType;
//   String? selectServicesPackage;
//   List<String>? servicesSelected;
//   String? ppfServicesName;
//   String? ppfServicesAmount;
//   String? ppfServicesType;
//   String? ppfServicesPackage;
//   List<String>? ppfServicesSelected;

//   BillListData(
//       {this.name,
//       this.id,
//       this.modelId,
//       this.phone,
//       this.date,
//       this.email,
//       this.address,
//       this.vehicleNumber,
//       this.modalName,
//       this.makeId,
//       this.year,
//       this.color,
//       this.vin,
//       this.gst,
//       this.segment,
//       this.estimatedDeliveryTime,
//       this.hsnNo,
//       this.totalServicesAmount,
//       this.couponCode,
//       this.totalDiscount,
//       this.assignedWorker,
//       this.totalTaxableAmount,
//       this.totalApplicableTax,
//       this.totalPayableAmount,
//       this.selectServicesName,
//       this.selectServicesPackage,
//       this.selectServicesAmount,
//       this.selectServicesType,
//       this.servicesSelected,
//       this.ppfServicesName,
//       this.ppfServicesAmount,
//       this.ppfServicesType,
//       this.ppfServicesPackage,
//       this.ppfServicesSelected});

//   BillListData.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     id = json["id"];
//     phone = json['phone'];
//     email = json['email'];
//     address = json['address'];
//     vehicleNumber = json['vehicle_number'];
//     modalName = json['modal_name'];
//     makeId = json['make_id'];
//     year = json['year'];
//     color = json['color'];
//     vin = json['vin'];
//     modelId = json["model_id"];
//     gst = json['gst'];
//     assignedWorker = json["assigned_worker"];
//     date = json["date"];
//     segment = json['segment'];
//     estimatedDeliveryTime = json['estimated_delivery_time'];
//     hsnNo = json['hsn_no'];
//     totalServicesAmount = json['total_services_amount'];
//     couponCode = json['coupon_code'];
//     totalDiscount = json['total_discount'];
//     totalTaxableAmount = json['total_taxable_amount'];
//     totalApplicableTax = json['total_applicable_tax'];
//     totalPayableAmount = json['total_payable_amount'];
//     selectServicesName = json['select_services_name'];
//     selectServicesAmount = json['select_services_amount'];
//     selectServicesPackage = json["select_services_package"];
//     selectServicesType = json["select_services_type"];
//     // servicesSelected = json['services_selected'].cast<String>();
//     servicesSelected = json['services_selected'] != null || json['services_selected'] != "[]" ? List<String>.from(jsonDecode(json['services_selected'])) : [];
//     ppfServicesName = json['ppf_services_name'];
//     ppfServicesType = json["ppf_services_type"];
//     ppfServicesAmount = json['ppf_services_amount'];
//     ppfServicesPackage = json["ppf_services_package"];
//     // ppfServicesSelected = json['ppf_services_selected'].cast<String>();
//     ppfServicesSelected =
//         json['ppf_services_selected'] != null || json['ppf_services_selected'] != "[]" ? List<String>.from(jsonDecode(json['ppf_services_selected'])) : [];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data["date"] = date;
//     data["model_id"] = modelId;
//     data['phone'] = this.phone;
//     data['email'] = this.email;
//     data['address'] = this.address;
//     data['vehicle_number'] = this.vehicleNumber;
//     data['modal_name'] = this.modalName;
//     data['make_id'] = this.makeId;
//     data['year'] = this.year;
//     data['color'] = this.color;
//     data['vin'] = this.vin;
//     data['gst'] = this.gst;
//     data['segment'] = this.segment;
//     data["assigned_worker"] = assignedWorker;
//     data['estimated_delivery_time'] = this.estimatedDeliveryTime;
//     data['hsn_no'] = this.hsnNo;
//     data['total_services_amount'] = this.totalServicesAmount;
//     data["select_services_package"] = selectServicesPackage;
//     data['coupon_code'] = this.couponCode;
//     data['total_discount'] = this.totalDiscount;
//     data['total_taxable_amount'] = this.totalTaxableAmount;
//     data['total_applicable_tax'] = this.totalApplicableTax;
//     data['total_payable_amount'] = this.totalPayableAmount;
//     data['select_services_name'] = this.selectServicesName;
//     data['select_services_amount'] = this.selectServicesAmount;
//     data["select_services_type"] = selectServicesType;
//     data['services_selected'] = this.servicesSelected;
//     data['ppf_services_name'] = this.ppfServicesName;
//     data["ppf_services_type"] = ppfServicesType;
//     data['ppf_services_amount'] = this.ppfServicesAmount;
//     data["ppf_services_package"] = ppfServicesPackage;
//     data['ppf_services_selected'] = this.ppfServicesSelected;
//     return data;
//   }
// }

class BillsListResponse {
  String? status;
  String? message;
  List<BillListData>? data;

  BillsListResponse({this.status, this.message, this.data});

  BillsListResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <BillListData>[];
      json['data'].forEach((v) {
        data!.add(new BillListData.fromJson(v));
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

class BillListData {
  int? id;
  int? userId;
  String? name;
  String? invoiceNo;
  String? serviceBarcode;
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
  List<SelectServices>? selectServices;
  List<PpfServices>? ppfServices;

  BillListData(
      {this.id,
      this.userId,
      this.name,
      this.invoiceNo,
      this.serviceBarcode,
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
      this.selectServices,
      this.ppfServices});

  BillListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    invoiceNo = json['invoice_no'];
    serviceBarcode = json['service_barcode'];
    date = json['date'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    vehicleNumber = json['vehicle_number'];
    modalName = json['modal_name'];
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
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['invoice_no'] = this.invoiceNo;
    data['service_barcode'] = this.serviceBarcode;
    data['date'] = this.date;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['address'] = this.address;
    data['vehicle_number'] = this.vehicleNumber;
    data['modal_name'] = this.modalName;
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

  PpfServices({this.name, this.type, this.package, this.amount});

  PpfServices.fromJson(Map<String, dynamic> json) {
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
