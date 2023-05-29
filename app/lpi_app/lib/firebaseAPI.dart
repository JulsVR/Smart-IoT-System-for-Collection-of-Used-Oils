import 'dart:html';

import 'package:http/http.dart' as http;
import 'dart:convert';

class APIResponse {
  double flowRE;
  double airRE;
  double humidRE;
  double liqRE;
  double turbRE;
  double beforetempRE;
  double waterRE;
  double food_oilRE;
  double engine_oilRE;
  TimeElement timeRE;

  APIResponse(
      {required this.flowRE,
      required this.airRE,
      required this.humidRE,
      required this.liqRE,
      required this.turbRE,
      required this.beforetempRE,
      required this.waterRE,
      required this.food_oilRE,
      required this.engine_oilRE,
      required this.timeRE});
}

class FirebaseAPI {
  static Future<APIResponse> fetchData() async {
    final String CHANNEL_ID = 'PLACEHOLDER';
    final String READ_API_KEY = 'PLACEHOLDER';
    final Uri url = Uri.parse('LINK HERE');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
    }
  }
}
