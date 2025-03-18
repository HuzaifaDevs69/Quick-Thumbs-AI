// String baseUrl = "http://192.168.156.21:1001/api/"; //! local
String baseUrl = "http://89.116.20.138:1001/api/"; //! live
// ccccc

// pm2 start app.js --name "QuickThumbs" --watch
// pm2 start npm --name "Sunco-Web" -- watch -- start
// ipconfig getifaddr en0

String loginURL = "${baseUrl}users/login";
String userUrl = "${baseUrl}users";
String thumbnailUrl = "${baseUrl}thumbnails";
String registerUrl = "${baseUrl}users";

String fluxLoraUrl = "https://fal.run/fal-ai/flux/dev";

// create class for store api keys below
class APIKeys {
  static const String chatGPT =
      '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';

  static const String gemini = 'AIzaSyAwpOKse68UFqKR63Byph7VfAQQn1FomzA';

  static const String falAIKey =
      'a0a1ba4d-2577-464f-a402-9d28e15c5cdd:3acda5a4d00a1cfb093689d22894ce33';
}
