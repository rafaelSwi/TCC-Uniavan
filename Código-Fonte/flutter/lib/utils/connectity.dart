import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:MegaObra/server/info.dart';

Future<bool> hasConnectionWithServer() async {
  String serverAddress = getBaseUrl();
  try {
    final response = await http.get(Uri.parse("${serverAddress}/check/ping"));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
