import 'dart:convert';
import 'package:baseapp/config.dart';
import 'package:baseapp/modelos/plan_model.dart';
import 'package:http/http.dart' as http;

String url = '${Config.baseUrl}/api/cancel-subscription';

Future<PlanModel> cancelSubscription(String tokenUser) async {
  final response = await http.post(Uri.parse(url), headers: {
    "Authorization": "Bearer $tokenUser",
    'Accept': 'application/json'
  });
  String body = utf8.decode(response.bodyBytes);
  print(body);
  final jsonData = planModelFromJson(body);
  jsonData.statusCode = response.statusCode;
  return jsonData;
}
