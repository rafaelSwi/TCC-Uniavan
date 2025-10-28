//import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final int id;
  final String name;
  final String cpf;
  final int role_id;
  final int schedule_id;
  final int permission_id;

  const User({
    required this.id,
    required this.name,
    required this.cpf,
    required this.role_id,
    required this.schedule_id,
    required this.permission_id,
  });
}

Future<void> fetchUsers() async {
  final url = Uri.parse('http://127.0.0.1:8000/user/all_full');

  try {
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer INSERT_TOKEN_HERE',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Users: $data");
      for (var i = 0; i < data.length; i++) {}
    } else {
      print("Failed to load data, something is wrong.");
    }
  } catch (e) {
    print("Error: $e");
  }
}

void main() {
  print("Hello!");
  fetchUsers();
}
