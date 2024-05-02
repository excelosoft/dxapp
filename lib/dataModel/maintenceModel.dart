// class MaintanceModel {
//   String? name;
//   int? id;
//   String? date;
//   String? phone;
//   String? vehicleNumber;
//   String? modalName;
//   String? makeId;
//   String? year;
//   String? color;
//   String? estimatedDeliveryTime;
//   String? selectServicesName;
//   String? selectServicesType;
//   String? selectServicesPackage;
//   String? maintenanceNumber;
//   String? dueDate;
//   String? doneDate;
//   String? charges;

//   MaintanceModel({
//     this.name,
//     this.id,
//     this.date,
//     this.phone,
//     this.vehicleNumber,
//     this.modalName,
//     this.makeId,
//     this.year,
//     this.color,
//     this.estimatedDeliveryTime,
//     this.selectServicesName,
//     this.selectServicesType,
//     this.selectServicesPackage,
//     this.maintenanceNumber,
//     this.dueDate,
//     this.doneDate,
//     this.charges,
//   });

//   // Adding a factory constructor to create a VehicleService instance from a Map
//   // Useful for converting JSON to VehicleService instance
//   factory MaintanceModel.fromJson(Map<String, dynamic> json) {
//     return MaintanceModel(
//       name: json['name'],
//       id: json['id'],
//       date: json['date'],
//       phone: json['phone'],
//       vehicleNumber: json['vehicle_number'],
//       modalName: json['modal_name'],
//       makeId: json['make_id'],
//       year: json['year'],
//       color: json['color'],
//       estimatedDeliveryTime: json['estimated_delivery_time'],
//       selectServicesName: json['select_services_name'],
//       selectServicesType: json['select_services_type'],
//       selectServicesPackage: json['select_services_package'],
//       maintenanceNumber: json['maintenance_number'],
//       dueDate: json['due_date'],
//       doneDate: json['done_date'],
//       charges: json['charges'],
//     );
//   }

//   // Method to convert VehicleService instance to a Map
//   // Useful for uploading data to a server or saving locally
//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'id': id,
//       'date': date,
//       'phone': phone,
//       'vehicle_number': vehicleNumber,
//       'modal_name': modalName,
//       'make_id': makeId,
//       'year': year,
//       'color': color,
//       'estimated_delivery_time': estimatedDeliveryTime,
//       'select_services_name': selectServicesName,
//       'select_services_type': selectServicesType,
//       'select_services_package': selectServicesPackage,
//       'maintenance_number': maintenanceNumber,
//       'due_date': dueDate,
//       'done_date': doneDate,
//       'charges': charges,
//     };
//   }
// }

class MaintanceModel {
  String? status;
  String? message;
  List<MaintanceModelData>? data;

  MaintanceModel({this.status, this.message, this.data});

  MaintanceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MaintanceModelData>[];
      json['data'].forEach((v) {
        data!.add(new MaintanceModelData.fromJson(v));
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

class MaintanceModelData {
  String? name;
  String? date;
  String? phone;
  String? vehicleNumber;
  String? modalName;
  String? makeId;
  String? year;
  String? color;
  String? estimatedDeliveryTime;
  String? selectServicesName;
  String? selectServicesType;
  String? selectServicesPackage;
  String? maintenanceNumber;
  List<String>? dueDate;
  List<String>? doneDate;
  String? charges;
  String? maintenanceCharges;
  String? tax;
  String? totalPayableAmount;

  MaintanceModelData(
      {this.name,
      this.date,
      this.phone,
      this.vehicleNumber,
      this.modalName,
      this.makeId,
      this.year,
      this.color,
      this.estimatedDeliveryTime,
      this.selectServicesName,
      this.selectServicesType,
      this.selectServicesPackage,
      this.maintenanceNumber,
      this.dueDate,
      this.doneDate,
      this.charges,
      this.maintenanceCharges,
      this.tax,
      this.totalPayableAmount});

  MaintanceModelData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    date = json['date'];
    phone = json['phone'];
    vehicleNumber = json['vehicle_number'];
    modalName = json['modal_name'];
    makeId = json['make_id'];
    year = json['year'];
    color = json['color'];
    estimatedDeliveryTime = json['estimated_delivery_time'];
    selectServicesName = json['select_services_name'];
    selectServicesType = json['select_services_type'];
    selectServicesPackage = json['select_services_package'];
    maintenanceNumber = json['maintenance_number'];
    dueDate = json['due_date'].cast<String>();
    doneDate = json['done_date'].cast<String>();
    charges = json['charges'];
    maintenanceCharges = json['maintenance_charges'];
    tax = json['tax'];
    totalPayableAmount = json['total_payable_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['date'] = this.date;
    data['phone'] = this.phone;
    data['vehicle_number'] = this.vehicleNumber;
    data['modal_name'] = this.modalName;
    data['make_id'] = this.makeId;
    data['year'] = this.year;
    data['color'] = this.color;
    data['estimated_delivery_time'] = this.estimatedDeliveryTime;
    data['select_services_name'] = this.selectServicesName;
    data['select_services_type'] = this.selectServicesType;
    data['select_services_package'] = this.selectServicesPackage;
    data['maintenance_number'] = this.maintenanceNumber;
    data['due_date'] = this.dueDate;
    data['done_date'] = this.doneDate;
    data['charges'] = this.charges;
    data['maintenance_charges'] = this.maintenanceCharges;
    data['tax'] = this.tax;
    data['total_payable_amount'] = this.totalPayableAmount;
    return data;
  }
}
