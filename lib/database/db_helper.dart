// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:qrcode_scanner/database/environment.dart';

class DatabaseHelper {
  Future<void> insertRecord(Map<String, dynamic> data) async {
    try {
      String uri = "$apiUrl/insert_record.php";
      var res = await http.post(Uri.parse(uri), body: {
        "user_name": data["user_name"],
        "members": data["members"],
        "user_start_time": data["user_start_time"],
        "user_end_time": data["user_end_time"],
        "user_date": data["user_date"],
        "user_place": data["user_place"],
        "entry_type": data["entry_type"],
        "number_auth": data["number_auth"],
      });
      try {
        print("Response Body: ${res.body}");
        var response = jsonDecode(res.body);
        print("Response JSON: $response");
        if (response["success"] == true) {
          print("Record Inserted");
        } else {
          print("Some Issue");
        }
      } catch (e) {
        print("JSON Parsing Error: $e");
      }
    } catch (e) {
      print(e);
    }
  }
}
