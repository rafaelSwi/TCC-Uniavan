import 'dart:convert';
import 'package:MegaObra/models/chunk.dart';
import 'package:MegaObra/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:MegaObra/l10n/generated/app_localizations.dart';
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/models/activity.dart';
import 'package:MegaObra/models/material.dart' as model;
import 'package:MegaObra/utils/error_messages.dart';

var activityUrl = "${getBaseUrl()}/activity";

Future<List<Activity>> getAssociatedActivities(
  BuildContext context,
  bool all,
) async {
  var token = getBearerToken();
  var url = Uri.parse("${activityUrl}/list");
  if (all) {
    url = Uri.parse("${activityUrl}/all");
  }

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
  } on FormatException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.DECODE_BODY, "$e", stacktrace: "${stacktrace}");
  } on http.ClientException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e", stacktrace: "${stacktrace}");
  } catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e", stacktrace: "${stacktrace}");
  }
  return List.empty();
}

Future<List<Activity>> getActivityRestrictions(BuildContext context, int activity_id) async {
  var token = getBearerToken();
  var url = Uri.parse("${activityUrl}/${activity_id}/restrictions");

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
  } on FormatException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.DECODE_BODY, "$e", stacktrace: "${stacktrace}");
  } on http.ClientException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e", stacktrace: "${stacktrace}");
  } catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e", stacktrace: "${stacktrace}");
  }
  return List.empty();
}

Future<List<User>> getActivityEmployees(BuildContext context, int activity_id) async {
  var token = getBearerToken();
  var url = Uri.parse("${activityUrl}/${activity_id}/employees");

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

Future<List<model.Material>> getActivityMaterials(BuildContext context, int activity_id) async {
  var token = getBearerToken();
  var url = Uri.parse("${activityUrl}/${activity_id}/materials");

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> data = jsonDecode(decodedResponse);
      List<model.Material> mappedListFromRequest = data.map((item) => model.Material.fromJson(item)).toList();
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

Future<List<CompleteChunk>> getActivityChunkStatus(BuildContext context, int activity_id) async {
  var token = getBearerToken();
  var url = Uri.parse("${activityUrl}/${activity_id}/chunks");

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final List<dynamic> data = jsonDecode(decodedResponse);
      List<CompleteChunk> mappedListFromRequest = data.map((item) => CompleteChunk.fromJson(item)).toList();
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

Future<Activity?> getActivityById(BuildContext context, int activity_id) async {
  var token = getBearerToken();
  var url = Uri.parse("${activityUrl}/${activity_id}");

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedResponse);
      return Activity.fromJson(data);
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

Future<List<Activity>> getAssociatedActivitiesByUserId(BuildContext context, int user_id) async {
  var token = getBearerToken();
  var url = Uri.parse("${activityUrl}/user/id/${user_id}/list");

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
  } on FormatException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.DECODE_BODY, "$e", stacktrace: "${stacktrace}");
  } on http.ClientException catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e", stacktrace: "${stacktrace}");
  } catch (e, stacktrace) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e", stacktrace: "${stacktrace}");
  }
  return List.empty();
}

Future<void> createNewActivityChunk(
  BuildContext context,
  int activity_id,
  ChunkCreate location_chunk,
) async {
  var token = getBearerToken();
  var url = Uri.parse("${activityUrl}/${activity_id}/chunk");

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(location_chunk.toJson()),
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

Future<void> createNewActivity(
  BuildContext context,
  ActivityCreate activity,
) async {
  var token = getBearerToken();
  var url = Uri.parse("${activityUrl}/create");

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(activity.toJson()),
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

Future<void> createNewCloneActivity(
  BuildContext context,
  ActivityClone activity,
  int baseActivityId,
) async {
  var token = getBearerToken();
  var url = Uri.parse("${activityUrl}/${baseActivityId}/clone");

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(activity.toJson()),
    );

    if ([200, 201].contains(response.statusCode)) {
      print("${url} - successfully cloned.");
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

Future<Activity?> updateActivityProperty(
  BuildContext context,
  int activity_id,
  Map<String, dynamic> updateData,
) async {
  var token = getBearerToken();
  var url = Uri.parse("${activityUrl}/${activity_id}");

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
      if (decodedResponse.isNotEmpty) {
        final data = jsonDecode(decodedResponse);
        if (data != null && data is Map<String, dynamic>) {
          return Activity.fromJson(data);
        }
      }
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else if (response.statusCode == 409) {
      ErrorMsg.throwError(context, url, ErrorMsg.INVALID, "${response.statusCode}");
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "${response.statusCode}");
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

Future<Activity?> updateActivityEmployees(
  BuildContext context,
  int activity_id,
  List<int> newIds,
) async {
  var token = getBearerToken();
  var url = Uri.parse("${activityUrl}/${activity_id}/employees");

  try {
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(newIds),
    );

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      if (decodedResponse.isNotEmpty) {
        final data = jsonDecode(decodedResponse);
        if (data != null && data is Map<String, dynamic>) {
          return Activity.fromJson(data);
        }
      }
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else if (response.statusCode == 409) {
      ErrorMsg.throwError(context, url, ErrorMsg.INVALID, "${response.statusCode}");
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "${response.statusCode}");
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

Future<Activity?> updateActivityRestrictions(
  BuildContext context,
  int activity_id,
  List<int> newIds,
) async {
  var token = getBearerToken();
  var url = Uri.parse("${activityUrl}/${activity_id}/restrictions");

  try {
    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(newIds),
    );

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      if (decodedResponse.isNotEmpty) {
        final data = jsonDecode(decodedResponse);
        if (data != null && data is Map<String, dynamic>) {
          return Activity.fromJson(data);
        }
      }
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else if (response.statusCode == 409) {
      ErrorMsg.throwError(context, url, ErrorMsg.INVALID, "${response.statusCode}");
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "${response.statusCode}");
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

Future<CompleteChunk?> updateActivityChunkProperty(
  BuildContext context,
  int activity_id,
  int chunk_status_id,
  Map<String, dynamic> updateData,
) async {
  var token = getBearerToken();
  var url = Uri.parse("${activityUrl}/${activity_id}/chunk/${chunk_status_id}");

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
      return null;
    } else if ([400, 401, 403].contains(response.statusCode)) {
      ErrorMsg.throwError(context, url, ErrorMsg.UNAUTHORIZED, null);
    } else if (response.statusCode == 409) {
      if (response.body.toLowerCase().contains("restrict")) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.restrictions,
          text: AppLocalizations.of(context)!.thisActivityHasRestrictions,
        );
      } else if (response.body.toLowerCase().contains("done")) {
        showAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.activity,
          text: AppLocalizations.of(context)!.activityAlreadyDone,
        );
      } else {
        ErrorMsg.throwError(context, url, ErrorMsg.INVALID, "${response.statusCode}");
      }
    } else {
      ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "${response.statusCode}");
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
