import 'dart:convert';
import 'package:MegaObra/models/token.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/utils/error_messages.dart';

var authUrl = "${getBaseUrl()}/auth";

Future<TokenWithUser?> getAccessToken(BuildContext context, String username, String password) async {
  var url = Uri.parse("${authUrl}/token");

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'password',
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedResponse);
      return TokenWithUser.fromJson(data);
    } else if ([400, 401].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.GET_TOKEN, "${response.statusCode}");
    }
  } catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e");
  }
  return null;
}
