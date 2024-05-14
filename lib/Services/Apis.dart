import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_dashboard/Services/BaseUrl.dart';
import 'package:responsive_dashboard/Services/request_url.dart';
import 'package:responsive_dashboard/constants/app_constant.dart';
import 'package:responsive_dashboard/dataModel/bill_list_model.dart';
import 'package:responsive_dashboard/dataModel/calendar_model.dart';
import 'package:responsive_dashboard/dataModel/estimate_list_model.dart';
import 'package:responsive_dashboard/dataModel/get_services_modal.dart';
import 'package:responsive_dashboard/dataModel/maintenceModel.dart';
import 'package:responsive_dashboard/dataModel/quatation_model.dart';
import 'package:responsive_dashboard/dataModel/user_data_model.dart';
import 'package:responsive_dashboard/dataModel/warranty_card_listing_model.dart';

import '../dataModel/jobsheet_listing_model.dart';

int? getUserId() {
  final userid = GetStorage().read('userId');
  AppConst.setAccessToken(userid);
  return userid;
}

class ApiProvider {
  var userid = getUserId();

  // get items--------
  Future<String?> getNewInvoiceNumber() async {
    try {
      var response = await http.post(
        Uri.parse('https://excelosoft.com/dxapp/public/api/invoiceList'),
        headers: ApiHeaders.apiHeader,
        body: jsonEncode({"user_id": userid}),
      );

      if (response.statusCode == 200) {
        // Parse the response body
        Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('data') && data['data'] is List && data['data'].isNotEmpty) {
          Map<String, dynamic> lastInvoice = data['data'].last;

          String invoiceNumber = lastInvoice['invoice_no'].toString().replaceAll('DX', '');

          String numbers = invoiceNumber.replaceAll(RegExp(r'[^0-9]'), '');

          // Convert the numbers to an integer and add 1
          int newNumber = int.parse(numbers) + 1;

          return newNumber.toString().padLeft(numbers.length, '0');
        }
      }
      return null;
    } catch (e) {
      print('Error fetching last invoice number: $e');
      return null;
    }
  }

  Future<EstimateListModel> getEstimateList() async {
    try {
      Map<String, dynamic> data = await postRequest(
        url: BaseUrl.estimateList,
        headers: ApiHeaders.apiHeader,
        body: {"user_id": userid},
      );

      if (data['status'] != null && data['status'] == '1') {
        print('data =====> $data');
        return EstimateListModel.fromJson(data);
      }
      return [] as EstimateListModel;
    } catch (e) {
      print(e.toString());
      return [] as EstimateListModel;
    }
  }

  Future<BillsListResponse> getBillList() async {
    Map<String, dynamic> data = await postRequest(
      url: BaseUrl.getBillListUrl,
      headers: ApiHeaders.apiHeader,
      body: {
        "user_id": userid,
      },
    );
    if (data['status'] != null && data['status'] == '1' || data['status'] == 1) {
      return BillsListResponse.fromJson(data);
    }
    return [] as BillsListResponse;
  }

  Future<JobSheetListingModel> getJobSheetList() async {
    Map<String, dynamic> data = await postRequest(
      url: BaseUrl.getJobSheetList,
      headers: ApiHeaders.apiHeader,
      body: {
        "user_id": userid,
        "vehicle_number": 'RJ14TA7217',
      },
    );
    if (data['status'] != null && data['status'] == '1' || data['status'] == 1) {
      return JobSheetListingModel.fromJson(data);
    }
    return [] as JobSheetListingModel;
  }

  Future<WarrantyCardListingModel> getWarrantyListing() async {
    Map<String, dynamic> data = await postRequest(
      url: BaseUrl.warrantyListingApi,
      headers: ApiHeaders.apiHeader,
      body: {"user_id": userid},
    );
    print('dataaaaaaaaaaaaaaa');
    print(data);
    if (data['status'] != null && data['status'] == '1' || data['status'] == 1) {
      return WarrantyCardListingModel.fromJson(data);
    }
    return [] as WarrantyCardListingModel;
  }
  Future<WarrantyCardListingModel2> getWarrantyListing2() async {
    Map<String, dynamic> data = await postRequest(
      url: BaseUrl.warrantyListingApi,
      headers: ApiHeaders.apiHeader,
      body: {"user_id": userid},
    );
    print('dataaaaaaaaaaaaaaa');
    print(data);
    if (data['status'] != null && data['status'] == '1' || data['status'] == 1) {
      return WarrantyCardListingModel2.fromJson(data);
    }
    return [] as WarrantyCardListingModel2;
  }

  Future<QuatationModel> getQuickQuationApi() async {
    Map<String, dynamic> data = await postRequest(
      url: BaseUrl.getQuickQuatation,
      headers: ApiHeaders.apiHeader,
      body: {"user_id": userid},
    );

    if (data['status'] != null && data['status'] == '1' || data['status'] == 1) {
      return QuatationModel.fromJson(data);
    }
    return [] as QuatationModel;
  }
  Future<List<MaintainestData>> getMaintenceList() async {
    try {
      Map<String, dynamic> data = await postRequest(
        url: 'https://excelosoft.com/dxapp/public/api/maintenanceList',
        headers: ApiHeaders.apiHeader,
        body: {"user_id": userid},
      );

      if (data['status'] != null && (data['status'] == '1' || data['status'] == 1)) {
        List<MaintainestData> maintenanceList = [];
        List<dynamic> dataList = data['data'] ?? [];
        for (var item in dataList) {
          maintenanceList.add(MaintainestData.fromJson(item));
        }
        return maintenanceList;
      } else {
        // Handle if status is not valid
        // For example: show an error message to the user
        throw Exception('Failed to fetch maintenance list');
      }
    } catch (e) {
      // Handle any exceptions during API call
      print('Error fetching maintenance list: $e');
      // You can also show an error message to the user
      throw e;
    }
  }
  // Future<List<MaintanceModel>> getMaintenceList() async {
  //   MaintanceModel maintenceList = [];
  //   var responseData = await http.post(
  //     Uri.parse('https://excelosoft.com/dxapp/public/api/maintenanceList'),
  //     headers: ApiHeaders.apiHeader,
  //     body: jsonEncode({"user_id": userid}),
  //   );
  //
  //   var model = jsonDecode(responseData.body.toString());
  //
  //   if (model['status'] != 0) {
  //     List modelData = model['data'];
  //     modelData.forEach((element) {
  //       maintenceList.add(MaintanceModel.fromJson(element));
  //     });
  //   }
  //   return maintenceList;
  // }
  //
  // Future<MaintainestListModel> getMaintenceList() async {
  //   // var responseData = await http.post(
  //   //   Uri.parse('https://excelosoft.com/dxapp/public/api/maintenanceList'),
  //   //   headers: ApiHeaders.apiHeader,
  //   //   body: jsonEncode({"user_id": userid}),
  //   // );
  //
  //   // var model = jsonDecode(responseData.body.toString());
  //
  //   // if (model['status'] != 0) {
  //   //   List modelData = model['data'];
  //   //   modelData.forEach((element) {
  //   //     maintenceList.add(MaintanceModel.fromJson(element));
  //   //   });
  //   // }
  //   try {
  //     Map<String, dynamic> data = await postRequest(
  //       url: 'https://excelosoft.com/dxapp/public/api/maintenanceList',
  //       headers: ApiHeaders.apiHeader,
  //       body: {"user_id": userid},
  //     );
  //     if (data['status'] != null && data['status'] == '1' ||
  //         data['status'] == 1) {
  //       return MaintainestListModel.fromJson(data);
  //     }else{
  //     return [] as MaintainestListModel;}
  //   }catch(e){
  //     print(e.toString());
  //     throw e;
  //   }
  // }

  Future<CalendarModel?> calendarListApi() async {
    try {
      Map<String, dynamic> data = await postRequest(
        url: BaseUrl.getCalendarList,
        headers: ApiHeaders.apiHeader,
        body: {"user_id": userid},
      );

      if (data['status'] != null && data['status'] == '1' || data['status'] == 1) {
        return CalendarModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<UserDataModel?> getProfile() async {
    Map<String, dynamic> data = await postRequest(url: BaseUrl.getProfile, headers: ApiHeaders.apiHeader, body: {"user_id": userid});
    if (data['status'] == 1 || data['status'] == '1') {
      return UserDataModel.fromJson(data);
    }
    return null;
  }

  Future<GetServicesModal> getAllServices() async {
    Map<String, dynamic> data = await getRequest(
      url: BaseUrl.getAllServicesApi,
      headers: ApiHeaders.apiHeader,
    );
    return GetServicesModal.fromJson(data);
  }

  serviceAPi() async {
    var response = await http.get(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getServices'),
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(response.body.toString());
    print(data);
    return data;
  }

  getServiceByName(String serviceName, String segment) async {
    try {
      var response = await http.post(
        Uri.parse('https://excelosoft.com/dxapp/public/api/getServiceByName'),
        headers: ApiHeaders.apiHeader,
        body: jsonEncode({
          "service_name": serviceName,
          "segment": segment,
        }),
      );
      var data = jsonDecode(response.body.toString());
      print(data);
      return data;
    } catch (e) {
      print(e);
    }
  }

  Future<List<String>> fetchBarcodeList() async {
    final response = await http.post(
      Uri.parse('https://excelosoft.com/dxapp/public/api/getProductBarcode'),
      headers: ApiHeaders.apiHeader,
      body: jsonEncode({"user_id": userid}),
    );
    print(response.body);
    // if (json.decode(response.body)['status'] == '1' || json.decode(response.body)['status'] == 1) {
    final jsonData = json.decode(response.body);
    final List<dynamic> data = jsonData['data'] ?? [];
    final List<String> barcodeList = data.map((item) => item['service_barcode'].toString()).toList();
    return barcodeList;
    // } else {
    //   toastification.show(
    //     context: context,
    //     type: ToastificationType.error,
    //     title: Text('Failed to load barcode list'),
    //     autoCloseDuration: const Duration(seconds: 5),
    //   );
    //   throw Exception('Failed to load barcode list');
    // }
  }

  // Store new items
  changeStatusForEstimate(String id, String selectedStatus) async {
    var response = await postRequest(
      url: 'https://excelosoft.com/dxapp/public/api/currentStatusUpdate/${id}',
      headers: ApiHeaders.apiHeader,
      body: {
        "current_status": selectedStatus,
        'user_id': userid,
      },
    );
    print(response);
  }

  storeJobSheet(Map dataMap) async {
    dataMap["user_id"] = userid;

    print(jsonEncode(dataMap));

    var response = await http.post(
      Uri.parse('https://excelosoft.com/dxapp/public/api/jobsheetsUpdate/${dataMap["estimateId"]}'),
      headers: ApiHeaders.apiHeader,
      body: jsonEncode(dataMap),
    );
    var data = jsonDecode(response.body.toString());
    print(data);
    return data;
  }

  storeWarrantyCard(Map dataMap, String id) async {
    dataMap["user_id"] = userid;

    try {
      var response = await http.post(
        Uri.parse('https://excelosoft.com/dxapp/public/api/warrantyCardsUpdate/$id'),
        headers: ApiHeaders.apiHeader,
        body: jsonEncode(dataMap),
      );
      var data = jsonDecode(response.body.toString());
      print(data);
      return data;
    } catch (e) {
      print('Error occurred: $e');
      return null; // or handle the error in a different way, such as showing a dialog to the user
    }
  }

  storeEstimateApi(Map dataMap) async {
    print(jsonEncode(dataMap));
    try {
      var headers = {'Content-Type': 'application/json'};
      var response = await http.post(
        Uri.parse('https://excelosoft.com/dxapp/public/api/estimatesStore'),
        headers: headers,
        body: jsonEncode(dataMap),
      );
      var data = jsonDecode(response.body.toString());
      print(data);
      return data;
    } catch (e) {
      print(e);
    }
  }

  storeQuickQuationApi(Map dataMap) async {
    dataMap["user_id"] = AppConst.getAccessToken();

    var response = await http.post(
      Uri.parse('https://excelosoft.com/dxapp/public/api/quickquotationsStore'),
      headers: ApiHeaders.apiHeader,
      body: jsonEncode(dataMap),
    );
    var data = jsonDecode(response.body.toString());
    print(data);
    return data;
  }

  storeMaintenance(Map dataMap, String id) async {
      dataMap["user_id"] = userid;

      var headers = {'Content-Type': 'application/json'};
      var response = await http.post(Uri.parse('https://excelosoft.com/dxapp/public/api/maintenanceUpdate/$id',), headers: headers, body: jsonEncode(dataMap));

          var data = jsonDecode(response.body.toString());
      print(data);
      return data;

  }

  storeInvoiceNumber(String invoiceNumber, String id) async {
    try {
      // Prepare the request body
      Map<String, dynamic> requestBody = {
        'user_id': userid,
        'id': id,
        'invoice_no': invoiceNumber,
      };

      // Make API request to store the invoice number
      var response = await http.post(
        Uri.parse('https://excelosoft.com/dxapp/public/api/invoiceStore'),
        body: jsonEncode(requestBody),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Invoice number stored successfully
        print('Invoice number stored successfully.');
      } else {
        // Failed to store invoice number
        print('Failed to store invoice number. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Error occurred while storing invoice number
      print('Error storing invoice number: $e');
    }
  }

  convertToBill(Map dataMap, String id) async {
    // estimateData["user_id"] = AppConst.getAccessToken();
    dataMap['user_id'] = userid;

    var headers = {'Content-Type': 'application/json'};
    var response = await http.post(
      Uri.parse('https://excelosoft.com/dxapp/public/api/billsUpdate/$id'),
      headers: headers,
      body: jsonEncode(dataMap),
    );
    var data = jsonDecode(response.body.toString());
    print(data);
    return data;
  }

  createCalendarEvent(Map dataMap) async {
    var headers = {'Content-Type': 'application/json'};
    var response = await http.post(Uri.parse('https://excelosoft.com/dxapp/public/api/calendarEventsStore'), headers: headers, body: jsonEncode(dataMap));
    var data = jsonDecode(response.body.toString());
    print(data);
    return data;
  }

// Update Items
  updateCalendarEvent(Map dataMap, String id) async {
    var headers = {'Content-Type': 'application/json'};
    var response = await http.post(Uri.parse('https://excelosoft.com/dxapp/public/api/calendarEventsUpdate/$id'), headers: headers, body: jsonEncode(dataMap));
    var data = jsonDecode(response.body.toString());
    return data;
  }

  updateQuickQuationApi(Map dataMap) async {
    dataMap["user_id"] = AppConst.getAccessToken();

    var response = await http.post(
      Uri.parse('https://excelosoft.com/dxapp/public/api/updateQuickQuotations'),
      headers: ApiHeaders.apiHeader,
      body: jsonEncode(dataMap),
    );
    var data = jsonDecode(response.body.toString());
    print(data);
    return data;
  }

  updateEstimateApi(Map dataMap, String id) async {
    var headers = {'Content-Type': 'application/json'};

    var response = await http.post(Uri.parse('https://excelosoft.com/dxapp/public/api/estimatesUpdate/$id'), headers: headers, body: jsonEncode(dataMap));

    var data = jsonDecode(response.body.toString());
    print(data);
    return data;
  }

//Delete Items
  deleteEstimateApi(int id) async {
    var dataMap = Map<String, String>();
    dataMap["id"] = id.toString();
    print(jsonEncode(dataMap));
    var response = await http.post(Uri.parse('https://excelosoft.com/dxapp/public/api/deleteEstimates'), headers: ApiHeaders.apiHeader, body: jsonEncode(dataMap));
    var data = jsonDecode(response.body.toString());
    print(data);
    return data;
  }

  deleteQuickQuatation(int id) async {
    var dataMap = Map<String, String>();
    dataMap["id"] = id.toString();
    var response = await http.post(Uri.parse('https://excelosoft.com/dxapp/public/api/deleteQuickQuotations'), headers: ApiHeaders.apiHeader, body: jsonEncode(dataMap));
    var data = jsonDecode(response.body.toString());
    print(data);
    return data;
  }

  deleteCalendarItemById(int id) async {
    var dataMap = Map<String, String>();
    dataMap["id"] = id.toString();
    var response = await http.post(Uri.parse('https://excelosoft.com/dxapp/public/api/calendarEventsDelete'), headers: ApiHeaders.apiHeader, body: jsonEncode(dataMap));
    var data = jsonDecode(response.body.toString());
    print(data);
    return data;
  }

  deleteBillsById(int id) async {
    var dataMap = Map<String, String>();
    dataMap["id"] = id.toString();
    var response = await http.post(Uri.parse('https://excelosoft.com/dxapp/public/api/billsDelete'), headers: ApiHeaders.apiHeader, body: jsonEncode(dataMap));
    var data = jsonDecode(response.body.toString());
    print(data);
    return data;
  }

  deleteJobSheetById(int id) async {
    var dataMap = Map<String, String>();
    dataMap["id"] = id.toString();
    var response = await http.post(Uri.parse('https://excelosoft.com/dxapp/public/api/jobsheetsDelete'), headers: ApiHeaders.apiHeader, body: jsonEncode(dataMap));
    var data = jsonDecode(response.body.toString());
    print(data);
    return data;
  }

  deleteWarrantyById(int id) async {
    var dataMap = Map<String, String>();
    dataMap["id"] = id.toString();
    var response = await http.post(Uri.parse('https://excelosoft.com/dxapp/public/api/warrantyCardsDelete'), headers: ApiHeaders.apiHeader, body: jsonEncode(dataMap));
    var data = jsonDecode(response.body.toString());
    print(data);
    return data;
  }
}


  // dynamic updateProfile(Map<String, dynamic> jsonMap) async {
  //   Map<String, dynamic> data = await postRequest(url: BaseUrl.updateProfileApi, headers: ApiHeaders.apiHeader, body: jsonMap);
  //   return data;
  // }
