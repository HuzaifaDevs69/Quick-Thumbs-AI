import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yt_thumb_extract/core/utils/app_logic.dart';
import 'package:yt_thumb_extract/core/utils/prefs/prefs_config.dart';
import 'package:yt_thumb_extract/data/models/user_model.dart';
import 'package:yt_thumb_extract/data/services/api_config.dart';
import 'package:yt_thumb_extract/presentation/widgets/custom_snackbar.dart';

class AuthController {
  static Future<dynamic> login({String? mobile, String? pass, context}) async {
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "MobileNo": mobile.toString().trim(),
        "Password": pass.toString().trim(),
      }),
    );

    var data = jsonDecode(response.body);
    if (data['status'] == 200) {
      CustomSnackbar.showSnackbar(
          context: context,
          title: "Success",
          message: data['message'],
          bgColor: Colors.green);

      PrefsConfig.setUserId(data['result']['UserId'].toString());
      // PrefsConfig.setRole(data['result']['Role.RoleName'].toString());
      // PrefsConfig.setToken(data['token']);
      Get.offAllNamed('/home');
      return UserModel.fromJson(data);
    } else {
      CustomSnackbar.showSnackbar(
        context: context,
        title: "Error",
        message: data['message'],
        bgColor: Color(0xFF9E0000),
      );
      return UserModel.fromJson(data);
    }
  }

  static Future<UserModel> getUsers() async {
    final response = await http.get(
      Uri.parse(userUrl),
      headers: {'Content-Type': 'application/json'},
    );

    var data = jsonDecode(response.body);
    if (data['status'] == 200) {
      return UserModel.fromJson(data);
    } else {
      return UserModel.fromJson(data);
    }
  }

  static Future deleteUser(int userId) async {
    final response = await http.get(
      Uri.parse(userUrl),
      headers: {'Content-Type': 'application/json'},
    );

    var data = jsonDecode(response.body);
    if (data['status'] == 200) {
      return data;
    } else {
      return data;
    }
  }

  static Future updateUser({
    required String password,
    required int roleId,
    required int userId,
    required bool isActive,
    required BuildContext context,
  }) async {
    final response = await http.put(
      Uri.parse(userUrl +
          userId.toString()), // Replace with your actual create user URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "IsActive": isActive,
        "Password": password.trim(),
        "RoleId": roleId,
      }),
    );

    var data = jsonDecode(response.body);
    if (data['status'] == 200) {
      CustomSnackbar.showSnackbar(
          context: context,
          title: "Success",
          message: data['message'],
          bgColor: Colors.green);
      Get.back(); // Navigate back to the previous screen or user list
    } else {
      CustomSnackbar.showSnackbar(
        context: context,
        title: "Error",
        message: data['message'],
        bgColor: Color(0xFF9E0000),
      );
    }
  }

  static Future<void> register({
    required String name,
    required String mobile,
    required String password,
    required BuildContext context,
  }) async {
    final response = await http.post(
      Uri.parse(registerUrl), // Your API endpoint for registration
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "Name": name.trim(),
        "MobileNo": mobile.trim(),
        "Password": password.trim(),
      }),
    );

    var data = jsonDecode(response.body);
    if (data['status'] == 200) {
      // CustomSnackbar.showSnackbar(
      //     context: context,
      //     title: "Success",
      //     message: data['message'],
      //     bgColor: Colors.green);

      dPrint.log(data.toString(), color: 'green');
      PrefsConfig.setIsLoggedIn(true);
      Get.offAllNamed('/login');
      return data;
    } else {
      dPrint.log(data.toString(), color: 'red');
      // CustomSnackbar.showSnackbar(
      //   context: context,
      //   title: "Error",
      //   message: data['message'],
      //   bgColor: Color(0xFF9E0000),
      // );
      return data;
    }
  }

  // static Future<bool> checkExpiration() async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse('$checkExpireUrl/${PrefsConfig.getUserId()}'),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);

  //       // Check the 'hasExpired' value from the response
  //       if (data['hasExpired'] != null) {
  //         return data['hasExpired']; // Return true or false based on expiration
  //       } else {
  //         // Handle the case where 'hasExpired' is not in the response (if needed)
  //         throw Exception('Invalid response format');
  //       }
  //     } else {
  //       // Handle non-200 responses
  //       throw Exception('Failed to check expiration: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     debugPrint('Error checking expiration: $error');
  //     throw Exception('Error checking expiration');
  //   }
  // }
}
