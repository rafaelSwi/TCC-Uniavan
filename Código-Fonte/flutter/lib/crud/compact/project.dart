import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/models/project.dart';
import 'package:MegaObra/models/compact/project.dart';
import 'package:MegaObra/utils/error_messages.dart';

var compactProjectUrl = "${getBaseUrl()}/project";

Future<ProjectCompactView?> getCompactProjectById(
  BuildContext context,
  int project_id,
) async {
  var token = getBearerToken();
  var url = Uri.parse("${compactProjectUrl}/${project_id.toString()}/compact");

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      var jsonData = jsonDecode(decodedResponse);
      return ProjectCompactView.fromJson(jsonData);
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.LOAD, "${response.statusCode}");
    }
  } on FormatException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.RESPONSE_FORMAT, "$e", stacktrace: "$stacktrace");
  } on http.ClientException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e", stacktrace: "$stacktrace");
  } catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e", stacktrace: "$stacktrace");
  }
  return null;
}
