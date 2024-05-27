class InvantaryModel {
  String? status;
  String? message;
  List<InvantaryData>? data;

  InvantaryModel({this.status, this.message, this.data});

  InvantaryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <InvantaryData>[];
      json['data'].forEach((v) {
        data!.add(new InvantaryData.fromJson(v));
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

class InvantaryData {
  int? id;
  int? userId;
  int? serviceId;
  int? inventoryId;
  String? serviceBarcode;
  String? barcodeImage;
  String? qty;
  String? amount;
  Null? sku;
  Null? barcode;
  String? date;
  int? status;
  String? customerId;
  String? invoiceNo;
  String? soldDate;
  String? createdAt;
  String? updatedAt;
  String? franchisee;
  String? serviceName;
  String? packageTime;

  InvantaryData(
      {this.id,
        this.userId,
        this.serviceId,
        this.inventoryId,
        this.serviceBarcode,
        this.barcodeImage,
        this.qty,
        this.amount,
        this.sku,
        this.barcode,
        this.date,
        this.status,
        this.customerId,
        this.invoiceNo,
        this.soldDate,
        this.createdAt,
        this.updatedAt,
        this.franchisee,
        this.serviceName,
        this.packageTime
      });

  InvantaryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    serviceId = json['service_id'];
    inventoryId = json['inventory_id'];
    serviceBarcode = json['service_barcode'];
    barcodeImage = json['barcode_image'];
    qty = json['qty'];
    amount = json['amount'];
    sku = json['sku'];
    barcode = json['barcode'];
    date = json['date'];
    status = json['status'];
    customerId = json['customer_id'];
    invoiceNo = json['invoice_no'];
    soldDate = json['sold_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    franchisee = json['franchisee'];
    serviceName = json['service_name'];
    packageTime = json['package_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['service_id'] = this.serviceId;
    data['inventory_id'] = this.inventoryId;
    data['service_barcode'] = this.serviceBarcode;
    data['barcode_image'] = this.barcodeImage;
    data['qty'] = this.qty;
    data['amount'] = this.amount;
    data['sku'] = this.sku;
    data['barcode'] = this.barcode;
    data['date'] = this.date;
    data['status'] = this.status;
    data['customer_id'] = this.customerId;
    data['invoice_no'] = this.invoiceNo;
    data['sold_date'] = this.soldDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['franchisee'] = this.franchisee;
    data['service_name'] = this.serviceName;
    data['package_time'] = this.packageTime;
    return data;
  }
}