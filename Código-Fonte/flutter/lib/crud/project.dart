import 'dart:convert';
import 'package:MegaObra/models/activity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/models/project.dart';
import 'package:MegaObra/utils/error_messages.dart';

var projectUrl = "${getBaseUrl()}/project";

Future<List<Project>> getAssociatedProjects(BuildContext context) async {
  var token = getBearerToken();
  var url = Uri.parse("${projectUrl}/list");

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> data = jsonDecode(decodedResponse);
      List<Project> mappedListFromRequest = data.map((item) => Project.fromJson(item)).toList();
      return mappedListFromRequest;
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "${response.statusCode}");
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

Future<List<Activity>> getProjectRain(BuildContext context, int project_id) async {
  var token = getBearerToken();
  var url = Uri.parse("${projectUrl}/${project_id.toString()}/rain");

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> data = jsonDecode(decodedResponse);
      List<Activity> mappedListFromRequest = data.map((item) => Activity.fromJson(item)).toList();
      return mappedListFromRequest;
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "${response.statusCode}");
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

Future<List<Activity>> getProjectActivity(BuildContext context, int project_id) async {
  var token = getBearerToken();
  var url = Uri.parse("${projectUrl}/${project_id.toString()}/activity");

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> data = jsonDecode(decodedResponse);
      List<Activity> mappedListFromRequest = data.map((item) => Activity.fromJson(item)).toList();
      return mappedListFromRequest;
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "${response.statusCode}");
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

Future<List<ProjectSuperSimplified>> getProjectsCloseToDeadline(
  BuildContext context,
  int? filterByUserId,
) async {
  var url = Uri.parse("${projectUrl}/deadline");
  var token = getBearerToken();
  if (filterByUserId != null) {
    url = Uri.parse("${getBaseUrl()}/user/id/${filterByUserId}/deadline");
  }

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> data = jsonDecode(decodedResponse);
      List<ProjectSuperSimplified> mappedListFromRequest = data.map((item) => ProjectSuperSimplified.fromJson(item)).toList();
      return mappedListFromRequest;
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "${response.statusCode}");
    }
  } on FormatException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.DECODE_BODY, "$e", stacktrace: "$stacktrace");
  } on http.ClientException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e", stacktrace: "$stacktrace");
  } catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e", stacktrace: "$stacktrace");
  }
  return List.empty();
}

Future<Project?> getProjectById(BuildContext context, int project_id) async {
  var token = getBearerToken();
  var url = Uri.parse("${projectUrl}/${project_id.toString()}");

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedResponse);
      return Project.fromJson(data);
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

Future<void> createNewProject(BuildContext context, ProjectCreate project) async {
  var token = getBearerToken();
  var url = Uri.parse("${projectUrl}/create");

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(project.toJson()),
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

Future<void> finishProject(BuildContext context, int project_id) async {
  var token = getBearerToken();
  var url = Uri.parse("${projectUrl}/${project_id.toString()}/finish");

  try {
    final response = await http.patch(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      print("${url} - successfully finished.");
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

Future<void> editProject(BuildContext context, ProjectEdit projectEdit) async {
  var token = getBearerToken();
  var url = Uri.parse("${projectUrl}/${projectEdit.id}");

  try {
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(projectEdit.toJson()),
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
