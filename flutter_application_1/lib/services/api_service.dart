// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
    // login utilizador
    static Future<bool> loginUser({
      required String email,
      required String password,
    }) async {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      return response.statusCode == 200;
    }
  static const String baseUrl = 'http://127.0.0.1:3000'; 

//registo urilizador
  static Future<bool> registerUser({
    required String nome,
    required String email,
    required String password,
    required String telemovel,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': nome,
        'email': email,
        'password': password,
        'telemovel': telemovel,
      }),
    );
    return response.statusCode == 201;
  }
}