class JobSheetListingModel {
  String? status;
  String? message;
  List<JobSheetListData>? data;

  JobSheetListingModel({this.status, this.message, this.data});

  JobSheetListingModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <JobSheetListData>[];
      json['data'].forEach((v) {
        data!.add(new JobSheetListData.fromJson(v));
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

class JobSheetListData {
  int? id;
  String? name;
  String? vehicleNumber;
  String? modalName;
  String? makeId;
  String? segment;
  String? color;
  String? year;
  String? vin;
  String? estimatedDeliveryTime;
  String? assignedWorker;
  String? description;
  String? ppfDescription;
  String? carphoto;
  String? remarks;
  List<SelectServices>? selectServices;
  List<PpfServices>? ppfServices;

  JobSheetListData(
      {this.id,
      this.name,
      this.vehicleNumber,
      this.modalName,
      this.makeId,
      this.segment,
      this.color,
      this.year,
      this.vin,
      this.estimatedDeliveryTime,
      this.assignedWorker,
      this.description,
      this.ppfDescription,
      this.carphoto,
      this.remarks,
      this.selectServices,
      this.ppfServices});

  JobSheetListData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    vehicleNumber = json['vehicle_number'];
    modalName = json['modal_name'];
    makeId = json['make_id'];
    segment = json['segment'];
    color = json['color'];
    year = json['year'];
    vin = json['vin'];
    estimatedDeliveryTime = json['estimated_delivery_time'];
    assignedWorker = json['assigned_worker'];
    description = json['description'];
    ppfDescription = json['ppf_description'];
    carphoto = json['carphoto'];
    remarks = json['remarks'];
    if (json['select_services'] != null) {
      selectServices = <SelectServices>[];
      json['select_services'].forEach((v) {
        selectServices!.add(new SelectServices.fromJson(v));
      });
    }
    if (json['select_services'] != null) {
      selectServices = <SelectServices>[];
      json['select_services'].forEach((v) {
        selectServices!.add(new SelectServices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['vehicle_number'] = this.vehicleNumber;
    data['modal_name'] = this.modalName;
    data['make_id'] = this.makeId;
    data['segment'] = this.segment;
    data['color'] = this.color;
    data['year'] = this.year;
    data['vin'] = this.vin;
    data['estimated_delivery_time'] = this.estimatedDeliveryTime;
    data['assigned_worker'] = this.assignedWorker;
    data['description'] = this.description;
    data['ppf_description'] = this.ppfDescription;
    data['carphoto'] = this.carphoto;
    data['remarks'] = this.remarks;
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
  String? servicesSelected;

  SelectServices({this.name, this.type, this.package, this.amount, this.servicesSelected});

  SelectServices.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    package = json['package'];
    amount = json['amount'];
    servicesSelected = json['services_selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['package'] = this.package;
    data['amount'] = this.amount;
    data['services_selected'] = this.servicesSelected;
    return data;
  }
}

class PpfServices {
  String? name;
  String? type;
  String? package;
  String? amount;
  List<String>? servicesSelected;

  PpfServices({this.name, this.type, this.package, this.amount, this.servicesSelected});

  PpfServices.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    package = json['package'];
    amount = json['amount'];
    servicesSelected = json['services_selected'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['package'] = this.package;
    data['amount'] = this.amount;
    data['services_selected'] = this.servicesSelected;
    return data;
  }
}


// class JobSheetListingModel {
//   String? status;
//   String? message;
//   List<JobsheetData>? data;

//   JobSheetListingModel({this.status, this.message, this.data});

//   JobSheetListingModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <JobsheetData>[];
//       json['data'].forEach((v) {
//         data!.add(JobsheetData.fromJson(v));
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

// class JobsheetData {
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
//   String? hsnNo;
//   String? assignedWorker;
//   String? totalServicesAmount;
//   String? couponCode;
//   String? totalDiscount;
//   String? totalTaxableAmount;
//   String? totalApplicableTax;
//   String? totalPayableAmount;
//   int? status;
//   int? jobsheetStatus;
//   String? carphoto;
//   String? remarks;
//   int? billsStatus;
//   int? warrantyStatus;
//   int? maintenanceStatus;
//   String? currentStatus;
//   String? createdAt;
//   String? updatedAt;
//   String? franchisee;
//   String? modalName;
//   String? selectServicesName;
//   String? selectServicesType;
//   String? selectServicesPackage;
//   String? selectServicesAmount;
//   String? servicesSelected;
//   String? description;
//   String? ppfServicesName;
//   String? ppfServicesType;
//   String? ppfServicesPackage;
//   String? ppfServicesAmount;
//   String? ppfServicesSelected;

//   JobsheetData(
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
//       this.hsnNo,
//       this.assignedWorker,
//       this.totalServicesAmount,
//       this.couponCode,
//       this.totalDiscount,
//       this.totalTaxableAmount,
//       this.totalApplicableTax,
//       this.totalPayableAmount,
//       this.status,
//       this.jobsheetStatus,
//       this.carphoto,
//       this.remarks,
//       this.billsStatus,
//       this.warrantyStatus,
//       this.maintenanceStatus,
//       this.currentStatus,
//       this.createdAt,
//       this.updatedAt,
//       this.franchisee,
//       this.modalName,
//       this.selectServicesName,
//       this.selectServicesType,
//       this.selectServicesPackage,
//       this.selectServicesAmount,
//       this.servicesSelected,
//       this.description,
//       this.ppfServicesName,
//       this.ppfServicesType,
//       this.ppfServicesPackage,
//       this.ppfServicesAmount,
//       this.ppfServicesSelected});

//   JobsheetData.fromJson(Map<String, dynamic> json) {
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
//     estimatedDeliveryTime = json['estimated_delivery_time'];
//     hsnNo = json['hsn_no'];
//     assignedWorker = json['assigned_worker'];
//     totalServicesAmount = json['total_services_amount'];
//     couponCode = json['coupon_code'];
//     totalDiscount = json['total_discount'];
//     totalTaxableAmount = json['total_taxable_amount'];
//     totalApplicableTax = json['total_applicable_tax'];
//     totalPayableAmount = json['total_payable_amount'];
//     status = json['status'];
//     jobsheetStatus = json['jobsheet_status'];
//     carphoto = json['carphoto'];
//     remarks = json['remarks'];
//     billsStatus = json['bills_status'];
//     warrantyStatus = json['warranty_status'];
//     maintenanceStatus = json['maintenance_status'];
//     currentStatus = json['current_status'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     franchisee = json['franchisee'];
//     modalName = json['modal_name'];
//     selectServicesName = json['select_services_name'];
//     selectServicesType = json['select_services_type'];
//     selectServicesPackage = json['select_services_package'];
//     selectServicesAmount = json['select_services_amount'];
//     servicesSelected = json['services_selected'];
//     description = json['description'];
//     ppfServicesName = json['ppf_services_name'];
//     ppfServicesType = json['ppf_services_type'];
//     ppfServicesPackage = json['ppf_services_package'];
//     ppfServicesAmount = json['ppf_services_amount'];
//     ppfServicesSelected = json['ppf_services_selected'];
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
//     data['estimated_delivery_time'] = this.estimatedDeliveryTime;
//     data['hsn_no'] = this.hsnNo;
//     data['assigned_worker'] = this.assignedWorker;
//     data['total_services_amount'] = this.totalServicesAmount;
//     data['coupon_code'] = this.couponCode;
//     data['total_discount'] = this.totalDiscount;
//     data['total_taxable_amount'] = this.totalTaxableAmount;
//     data['total_applicable_tax'] = this.totalApplicableTax;
//     data['total_payable_amount'] = this.totalPayableAmount;
//     data['status'] = this.status;
//     data['jobsheet_status'] = this.jobsheetStatus;
//     data['carphoto'] = this.carphoto;
//     data['remarks'] = this.remarks;
//     data['bills_status'] = this.billsStatus;
//     data['warranty_status'] = this.warrantyStatus;
//     data['maintenance_status'] = this.maintenanceStatus;
//     data['current_status'] = this.currentStatus;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['franchisee'] = this.franchisee;
//     data['modal_name'] = this.modalName;
//     data['select_services_name'] = this.selectServicesName;
//     data['select_services_type'] = this.selectServicesType;
//     data['select_services_package'] = this.selectServicesPackage;
//     data['select_services_amount'] = this.selectServicesAmount;
//     data['services_selected'] = this.servicesSelected;
//     data['description'] = this.description;
//     data['ppf_services_name'] = this.ppfServicesName;
//     data['ppf_services_type'] = this.ppfServicesType;
//     data['ppf_services_package'] = this.ppfServicesPackage;
//     data['ppf_services_amount'] = this.ppfServicesAmount;
//     data['ppf_services_selected'] = this.ppfServicesSelected;
//     return data;
//   }
// }