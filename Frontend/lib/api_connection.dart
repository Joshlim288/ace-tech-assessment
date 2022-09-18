import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

/// Provides methods to the rest of the application for calling the backend APIs
class ApiConnection {
  final http.Client client = http.Client();
  static const String baseUrl = "http://127.0.0.1:5000/";

  /// Enter a new batch of teams into the system
  static Future<void> enterTeams(String teams, Function(String) callback) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('$baseUrl/teams'));
    request.body = json.encode({"teams": teams});
    request.headers.addAll(headers);
    sendRequest(request, callback);
  }

  /// enter match results into the system
  static Future<void> enterResults(String results, Function(String) callback) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('$baseUrl/results'));
    request.body = json.encode({"results": results});
    request.headers.addAll(headers);
    sendRequest(request, callback);
  }

  /// get list of teams currently entered in the system
  /// backend handles the calculation of placements
  static Future<void> getScoreboard(Function(String) callback) async {
    var request = http.Request('GET', Uri.parse('$baseUrl/scoreboard'));
    sendRequest(request, callback);
  }

  /// Clear all data from the system
  static Future<void> clearData(Function(String) callback) async {
    var request = http.Request('DELETE', Uri.parse('$baseUrl/teams'));
    sendRequest(request, callback);
  }

  /// Abstract out code that will be sent for every request
  static Future<void> sendRequest(var request, Function(String) callback) async {
    try {
      http.StreamedResponse response = await request.send().timeout(const Duration(seconds: 10));
      callback(await response.stream.bytesToString());
    } on TimeoutException catch (e) {
      callback("Request timed out");
    }
  }
}
