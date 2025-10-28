import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/models/user.dart';
import 'package:MegaObra/utils/error_messages.dart';

var userUrl = "${getBaseUrl()}/user";

Future<List<User>> getAllUsers(BuildContext context) async {
  var token = getBearerToken();
  var url = Uri.parse("${userUrl}/all");

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> data = jsonDecode(decodedResponse);
      List<User> mappedListFromRequest = data.map((item) => User.fromJson(item)).toList();
      return mappedListFromRequest;
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.LOAD_USER, "${response.statusCode}");
    }
  } on FormatException catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.DECODE_BODY, "$e");
  } on http.ClientException catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e");
  } catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e");
  }
  return List.empty();
}

Future<User?> getUserById(BuildContext context, int user_id) async {
  var token = getBearerToken();
  var url = Uri.parse("${userUrl}/id/${user_id}");

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedResponse);
      return User.fromJson(data);
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.LOAD_USER, "${response.statusCode}");
    }
  } on FormatException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.RESPONSE_FORMAT, "$e", stacktrace: "${stacktrace}");
  } on http.ClientException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e", stacktrace: "${stacktrace}");
  } catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e", stacktrace: "${stacktrace}");
  }
  return null;
}

Future<User?> getUserByCpf(BuildContext context, String cpf) async {
  var token = getBearerToken();
  var url = Uri.parse("${userUrl}/cpf/${cpf}");

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedResponse);
      return User.fromJson(data);
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.LOAD_USER, "${response.statusCode}");
    }
  } on FormatException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.RESPONSE_FORMAT, "$e", stacktrace: "${stacktrace}");
  } on http.ClientException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e", stacktrace: "${stacktrace}");
  } catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e", stacktrace: "${stacktrace}");
  }
  return null;
}

Future<void> createNewUser(BuildContext context, UserCreate user, {bool rise = false}) async {
  var token = getBearerToken();
  var url = Uri.parse("${userUrl}/create");
  if (rise) {
    url = Uri.parse("${userUrl}/rise");
  }

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(user.toJson()),
    );

    if ([200, 201].contains(response.statusCode)) {
      print("${url} - successfully created.");
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else if ([410].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.DEPRECATED_GONE, null);
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.POST_USER, "${response.statusCode}");
    }
  } on FormatException catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.RESPONSE_FORMAT, "$e");
  } on http.ClientException catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e");
  } catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e");
  }
}

Future<User?> updateUserProperty(
  BuildContext context,
  int user_id,
  Map<String, dynamic> updateData,
) async {
  var token = getBearerToken();
  var url = Uri.parse("${userUrl}/id/${user_id}");

  try {
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updateData),
    );

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedResponse);
      return User.fromJson(data);
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.LOAD_USER, "${response.statusCode}");
    }
  } on FormatException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.RESPONSE_FORMAT, "$e", stacktrace: "${stacktrace}");
  } on http.ClientException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e", stacktrace: "${stacktrace}");
  } catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e", stacktrace: "${stacktrace}");
  }
  return null;
}
