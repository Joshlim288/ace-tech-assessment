import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiConnection {
  final http.Client client = http.Client();
  final String baseUrl = "http://127.0.0.1:5000/";

  /// Enter a new batch of teams into the system
  static Future<bool> enterTeams(String teams) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('http://127.0.0.1:5000/teams'));
    request.body = json.encode({"teams": teams});
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    return response.statusCode == 200;
  }
}
