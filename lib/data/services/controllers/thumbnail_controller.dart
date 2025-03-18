import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yt_thumb_extract/data/models/thumbnail_model.dart';
import 'package:yt_thumb_extract/data/services/api_config.dart';
import 'package:yt_thumb_extract/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';

class ThumbnailService {
// {
//   "UserId": 1,
//   "VideoUrl": "https://example.com/video.mp4",
//   "ImageUrl": "https://example.com/thumbnail.jpg",
//   "EditedImageUrl": "https://example.com/edited-thumbnail.jpg",
//   "Platform": "YouTube",
//   "createdAt": "2025-01-30T12:00:00Z"
// }

  static Future<ThumbnailModel?> createThumbnail(int userId, String videoUrl,
      String imageUrl, BuildContext context) async {
    final response = await http.post(
      Uri.parse(thumbnailUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "UserId": userId,
        "VideoUrl": videoUrl,
        "ImageUrl": imageUrl,
        "EditedImageUrl": "",
      }),
    );

    var data = jsonDecode(response.body);
    if (data['status'] == 200) {
      CustomSnackbar.showSnackbar(
        context: context,
        title: "Success",
        message: data['message'],
        bgColor: Colors.green,
      );
      return ThumbnailModel.fromJson(data['result']);
    } else {
      CustomSnackbar.showSnackbar(
        context: context,
        title: "Error",
        message: data['message'],
        bgColor: Color(0xFF9E0000),
      );
      return null;
    }
  }

  // Get all thumbnails
  static Future<ThumbnailModel> getThumbnails(BuildContext context) async {
    final response = await http.get(
      Uri.parse(thumbnailUrl),
      headers: {'Content-Type': 'application/json'},
    );

    var data = jsonDecode(response.body);
    if (data['status'] == 200) {
      return ThumbnailModel.fromJson(data);
    } else {
      CustomSnackbar.showSnackbar(
        context: context,
        title: "Error",
        message: data['message'],
        bgColor: Color(0xFF9E0000),
      );
      return ThumbnailModel.fromJson(data);
    }
  }

  // Update a thumbnail
  static Future<ThumbnailModel?> updateThumbnail({
    required int thumbnailId,
    required String videoUrl,
    required String imageUrl,
    required String editedImageUrl,
    required String platform,
    required BuildContext context,
  }) async {
    final response = await http.put(
      Uri.parse('$thumbnailUrl/$thumbnailId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "VideoUrl": videoUrl,
        "ImageUrl": imageUrl,
        "EditedImageUrl": editedImageUrl,
        "Platform": platform,
      }),
    );

    var data = jsonDecode(response.body);
    if (data['status'] == 200) {
      CustomSnackbar.showSnackbar(
        context: context,
        title: "Success",
        message: data['message'],
        bgColor: Colors.green,
      );
      return ThumbnailModel.fromJson(data['result']);
    } else {
      CustomSnackbar.showSnackbar(
        context: context,
        title: "Error",
        message: data['message'],
        bgColor: Color(0xFF9E0000),
      );
      return null;
    }
  }

  // Delete a thumbnail
  static Future<bool> deleteThumbnail(
      int thumbnailId, BuildContext context) async {
    final response = await http.delete(
      Uri.parse('$thumbnailUrl/$thumbnailId'),
      headers: {'Content-Type': 'application/json'},
    );

    var data = jsonDecode(response.body);
    if (data['status'] == 200) {
      CustomSnackbar.showSnackbar(
        context: context,
        title: "Success",
        message: data['message'],
        bgColor: Colors.green,
      );
      return true;
    } else {
      CustomSnackbar.showSnackbar(
        context: context,
        title: "Error",
        message: data['message'],
        bgColor: Color(0xFF9E0000),
      );
      return false;
    }
  }
}
