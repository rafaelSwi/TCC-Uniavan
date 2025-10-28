import 'dart:convert';
import 'package:MegaObra/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/models/schedule.dart';
import 'package:MegaObra/utils/error_messages.dart';

var scheduleUrl = "${getBaseUrl()}/schedule";

Future<List<Schedule>> getAllSchedules(BuildContext context) async {
  var token = getBearerToken();
  var url = Uri.parse("${scheduleUrl}/all");

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> data = jsonDecode(decodedResponse);
      List<Schedule> mappedListFromRequest = data.map((item) => Schedule.fromJson(item)).toList();
      return mappedListFromRequest;
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "${response.statusCode}");
    }
  } on FormatException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.DECODE_BODY, "$e", stacktrace: "${stacktrace}");
  } on http.ClientException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e", stacktrace: "${stacktrace}");
  } catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e", stacktrace: "${stacktrace}");
  }
  return List.empty();
}

Future<List<ScheduleCompact>> getAllCompactSchedules(BuildContext context) async {
  var token = getBearerToken();
  var url = Uri.parse("${scheduleUrl}/list");

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> data = jsonDecode(decodedResponse);
      List<ScheduleCompact> mappedListFromRequest = data.map((item) => ScheduleCompact.fromJson(item)).toList();
      return mappedListFromRequest;
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "${response.statusCode}");
    }
  } on FormatException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.DECODE_BODY, "$e", stacktrace: "${stacktrace}");
  } on http.ClientException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e", stacktrace: "${stacktrace}");
  } catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e", stacktrace: "${stacktrace}");
  }
  return List.empty();
}

Future<List<User>> getAllScheduleUsers(
  BuildContext context,
  int schedule_id,
) async {
  var token = getBearerToken();
  var url = Uri.parse("${scheduleUrl}/${schedule_id}/users");

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
      ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "${response.statusCode}");
    }
  } on FormatException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.DECODE_BODY, "$e", stacktrace: "${stacktrace}");
  } on http.ClientException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e", stacktrace: "${stacktrace}");
  } catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e", stacktrace: "${stacktrace}");
  }
  return List.empty();
}

Future<Schedule?> getScheduleById(BuildContext context, int schedule_id) async {
  var token = getBearerToken();
  var url = Uri.parse("${scheduleUrl}/${schedule_id}");

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedResponse);
      return Schedule.fromJson(data);
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.LOAD, "${response.statusCode}");
    }
  } on FormatException catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.RESPONSE_FORMAT, "$e");
  } on http.ClientException catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e");
  } catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e");
  }
  return null;
}

Future<bool> markScheduleAsDeprecated(
  BuildContext context,
  int schedule_id,
) async {
  var token = getBearerToken();
  var url = Uri.parse("${scheduleUrl}/${schedule_id}");

  try {
    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      return true;
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.LOAD, "${response.statusCode}");
    }
  } on FormatException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.RESPONSE_FORMAT, "$e", stacktrace: "${stacktrace}");
  } on http.ClientException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e", stacktrace: "${stacktrace}");
  } catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e", stacktrace: "${stacktrace}");
  }
  return false;
}

Future<void> createNewSchedule(BuildContext context, ScheduleCreate schedule) async {
  var token = getBearerToken();
  var url = Uri.parse("${scheduleUrl}/create");

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(schedule.toJson()),
    );

    if ([200, 201].contains(response.statusCode)) {
      print("${url} - successfully created.");
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.POST, "${response.statusCode}");
    }
  } on FormatException catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.RESPONSE_FORMAT, "$e");
  } on http.ClientException catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e");
  } catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e");
  }
}

Future<void> editSchedule(BuildContext context, int schedule_id, ScheduleCreate schedule) async {
  var token = getBearerToken();
  var url = Uri.parse("${scheduleUrl}/${schedule_id}");

  try {
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(schedule.toJson()),
    );

    if ([200, 201].contains(response.statusCode)) {
      print("${url} - successfully edited.");
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.POST, "${response.statusCode}");
    }
  } on FormatException catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.RESPONSE_FORMAT, "$e");
  } on http.ClientException catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e");
  } catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e");
  }
}
