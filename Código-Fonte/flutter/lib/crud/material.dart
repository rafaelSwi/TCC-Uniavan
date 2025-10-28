import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:MegaObra/server/info.dart';
import 'package:MegaObra/models/material.dart' as model;
import 'package:MegaObra/utils/error_messages.dart';

var materialUrl = "${getBaseUrl()}/material";

Future<List<model.Material>> getAllMaterials(BuildContext context) async {
  var token = getBearerToken();
  var url = Uri.parse("${materialUrl}/all");

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
  } on FormatException catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.DECODE_BODY, "$e");
  } on http.ClientException catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.NETWORK, "$e");
  } catch (e) {
    ErrorMsg.throwError(context, url, ErrorMsg.GENERIC, "$e");
  }
  return List.empty();
}

Future<model.Material?> getMaterialById(BuildContext context, int material_id) async {
  var token = getBearerToken();
  var url = Uri.parse("${materialUrl}/${material_id}");

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if ([200].contains(response.statusCode)) {
      String decodedResponse = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decodedResponse);
      return model.Material.fromJson(data);
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

Future<void> createNewMaterial(
  BuildContext context,
  model.MaterialBase material,
) async {
  var token = getBearerToken();
  var url = Uri.parse("${materialUrl}/create");

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(material.toJson()),
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
