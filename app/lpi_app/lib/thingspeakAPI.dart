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
  //TimeElement timeRE;

  APIResponse({
    required this.flowRE,
    required this.airRE,
    required this.humidRE,
    required this.liqRE,
    required this.turbRE,
    required this.beforetempRE,
    required this.waterRE,
    required this.food_oilRE,
  });
}

class ThingSpeakAPI {
  static Future<APIResponse> fetchData() async {
    final String CHANNEL_ID = 'PLACEHOLDER';
    final String READ_API_KEY = 'PLACEHOLDER';
    final int results = 1;
    final Uri url = Uri.parse(
        'https://api.thingspeak.com/channels/$CHANNEL_ID/feeds.json?api_key=$READ_API_KEY&results=$results');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final feeds = data['feeds'];

      // Check if feeds is not empty
      if (feeds.isNotEmpty) {
        final feed = feeds[0]; // Get the first feed

        final fluxo = feed['PLACEHOLDER'].toDouble();
        final temp_ar = feed['PLACEHOLDER'].toDouble();
        final humidade = feed['PLACEHOLDER'].toDouble();
        final temp_liq = feed['PLACEHOLDER'].toDouble();
        final turbidez = feed['PLACEHOLDER'].toDouble();
        final temp_antes = feed['PLACEHOLDER'].toDouble();
        final agua = feed['PLACEHOLDER'].toDouble();
        final oleo_alim = feed['PLACEHOLDER'].toDouble();

        final apiResponse = APIResponse(
          flowRE: fluxo,
          airRE: temp_ar,
          humidRE: humidade,
          liqRE: temp_liq,
          turbRE: turbidez,
          beforetempRE: temp_antes,
          waterRE: agua,
          food_oilRE: oleo_alim,
        );

        return apiResponse;
      } else {
        throw Exception('No data available');
      }
    } else {
      throw Exception('Failed to load data from ThingSpeak API');
    }
  }
}
