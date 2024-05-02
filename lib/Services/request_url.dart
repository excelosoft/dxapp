import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiHeaders {
  static Map<String, String> authApiHeader = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    // 'Authorization': 'Bearer ${AppConst.getAccessToken()}',
  };

  static Map<String, String> apiHeader = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    "Access-Control-Allow-Origin": "*",
  };

  static Map<String, String> formDataAuthApiHeader = {
    'Accept': '*/*',
    'Content-Type': 'multipart/form-data',
    // 'Authorization': 'Bearer ${AppConst.getAccessToken()}',
  };

  static Map<String, String> fromDataApiHeader = {
    'Accept': '*/*',
    'Content-Type': 'multipart/form-data',
    // 'Authorization': 'Bearer ${AppConst.getAccessToken()}',
  };
}

Future<dynamic> postRequest({required String url, required Map<String, String>? headers, required Map<String, dynamic> body}) async {
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: json.encode(body),
    );

    return jsonDecode(response.body);
  } catch (e) {
    if (kDebugMode) {
      print('Data and image upload failed with error: $e');
    }
  }
}

Future<dynamic> getRequest({
  required String url,
  required Map<String, String> headers,
  Map<String, dynamic>? body,
}) async {
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    );
    return jsonDecode(response.body);
  } catch (e) {
    if (kDebugMode) {
      print('An error occurred: $e');
    }
  }
}

Future<dynamic> formDataPostRequest({required String url, required Map<String, dynamic> fields, required imageFile}) async {
  var request = http.MultipartRequest('POST', Uri.parse(url));

  fields.forEach((key, value) {
    request.fields[key] = value;
  });

  request.files.add(await http.MultipartFile.fromPath('image', imageFile));
  try {
    http.StreamedResponse response = await request.send();
    final res = await response.stream.bytesToString();
    return jsonDecode(res);
  } catch (e) {
    if (kDebugMode) {
      print('Data and image upload failed with error: $e');
    }
  }
}
