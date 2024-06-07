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
  List<MaintainestData>? data;

  MaintanceModel({this.status, this.message, this.data});

  MaintanceModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MaintainestData>[];
      json['data'].forEach((v) {
        data!.add(new MaintainestData.fromJson(v));
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

class MaintainestData {
  int? id;
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

  String? charges;
  String? maintenanceCharges;
  String? tax;
  String? totalPayableAmount;

  MaintainestData(

      {
        this.id,

        this.name,
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

      this.charges,
      this.maintenanceCharges,
      this.tax,
      this.totalPayableAmount});

  MaintainestData.fromJson(Map<String, dynamic> json) {
    id=json['id'];
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
    data['charges'] = this.charges;
    data['maintenance_charges'] = this.maintenanceCharges;
    data['tax'] = this.tax;
    data['total_payable_amount'] = this.totalPayableAmount;
    return data;
  }
}
class MaintenanceData {
  int id;
  String name;
  String date;
  String phone;
  String vehicleNumber;
  String modalName;
  String makeId;
  String year;
  String color;
  String estimatedDeliveryTime;
  String selectServicesName;
  String selectServicesType;
  String selectServicesPackage;
  String maintenanceNumber;
  List<String> dueDate;
  List<String> doneDate;
  String maintenanceCharges;
  String tax;
  String totalPayableAmount;

  MaintenanceData({
    required this.id,
    required this.name,
    required this.date,
    required this.phone,
    required this.vehicleNumber,
    required this.modalName,
    required this.makeId,
    required this.year,
    required this.color,
    required this.estimatedDeliveryTime,
    required this.selectServicesName,
    required this.selectServicesType,
    required this.selectServicesPackage,
    required this.maintenanceNumber,
    required this.dueDate,
    required this.doneDate,
    required this.maintenanceCharges,
    required this.tax,
    required this.totalPayableAmount,
  });

  factory MaintenanceData.fromJson(Map<String, dynamic> json) {
    return MaintenanceData(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      phone: json['phone'],
      vehicleNumber: json['vehicle_number'],
      modalName: json['modal_name'],
      makeId: json['make_id'],
      year: json['year'],
      color: json['color'],
      estimatedDeliveryTime: json['estimated_delivery_time'],
      selectServicesName: json['select_services_name'],
      selectServicesType: json['select_services_type'],
      selectServicesPackage: json['select_services_package'],
      maintenanceNumber: json['maintenance_number'],
      dueDate: List<String>.from(json['due_date']),
      doneDate: List<String>.from(json['done_date']),
      maintenanceCharges: json['maintenance_charges'],
      tax: json['tax'],
      totalPayableAmount: json['total_payable_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'phone': phone,
      'vehicle_number': vehicleNumber,
      'modal_name': modalName,
      'make_id': makeId,
      'year': year,
      'color': color,
      'estimated_delivery_time': estimatedDeliveryTime,
      'select_services_name': selectServicesName,
      'select_services_type': selectServicesType,
      'select_services_package': selectServicesPackage,
      'maintenance_number': maintenanceNumber,
      'due_date': dueDate,
      'done_date': doneDate,
      'maintenance_charges': maintenanceCharges,
      'tax': tax,
      'total_payable_amount': totalPayableAmount,
    };
  }
}

