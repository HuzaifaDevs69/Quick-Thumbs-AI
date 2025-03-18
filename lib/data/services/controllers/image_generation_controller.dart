import 'package:fal_client/fal_client.dart';
import 'package:flutter/material.dart';
import 'package:yt_thumb_extract/core/utils/app_logic.dart';
import 'package:yt_thumb_extract/data/services/api_config.dart';

class ImageGenerateController {
  // imp Flux AI
  static final fal = FalClient.withCredentials(APIKeys.falAIKey);

  static Future<Map<String, dynamic>> textToImage({
    required String prompt,
    required String imageUrl,
    required BuildContext context,
  }) async {
    try {
      final output = await fal.subscribe(
        'fal-ai/flux/dev/image-to-image',
        input: {
          "prompt": prompt,
          "image_url": imageUrl,
          "image_size": "landscape_4_3",
          "num_inference_steps": 28,
          "guidance_scale": 3.5,
          "num_images": 1,
          "enable_safety_checker": true,
          "output_format": "jpeg",
          "loras": []
        },
        onQueueUpdate: (update) {
          dPrint.log("🔄 Queue Update: ${update.status}", color: 'blue');
        },
      );

      dPrint.log("✅ Image generated successfully: ${output.data}",
          color: 'green');
      return output.data;
    } catch (e) {
      dPrint.log("⚠️ Exception: ${e.toString()}", color: 'yellow');
      return {"error": "Exception occurred", "message": e.toString()};
    }
  }
}
