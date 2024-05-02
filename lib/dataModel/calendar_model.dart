class CalendarModel {
  String? status;
  String? message;
  List<CalendarItem>? data;

  CalendarModel({this.status, this.message, this.data});

  CalendarModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CalendarItem>[];
      json['data'].forEach((v) {
        data!.add(new CalendarItem.fromJson(v));
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

class CalendarItem {
  int? id;
  int? userId;
  String? title;
  String? startDate;
  String? endDate;
  String? createdAt;
  String? updatedAt;
  String? franchisee;

  CalendarItem({this.id, this.userId, this.title, this.startDate, this.endDate, this.createdAt, this.updatedAt, this.franchisee});

  CalendarItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    franchisee = json['franchisee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['franchisee'] = this.franchisee;
    return data;
  }
}
