// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Nota: se estiveres a correr o backend num emulador Android usa 10.0.2.2
  // Em iOS simulator ou dispositivo real usa o IP/URL do servidor
  static const String baseUrl = 'http://localhost:3000'; // ajusta conforme necessário

  // -------------------------
  // LOGIN
  // -------------------------
  // Retorna true se login bem sucedido (também guarda token + user localmente)
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

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final token = body['token'];
      final user = body['user'];

      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user', json.encode(user));
        return true;
      }
    } else {
      print('Login falhou: ${response.statusCode} ${response.body}');
    }
    return false;
  }

  // Recupera token guardado (ou null)
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Remove token + user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }

  // -------------------------
  // REGISTER USER
  // -------------------------
  // Faz register e tenta fazer login automático (guarda token)
  // Retorna true se, no final, o utilizador estiver autenticado
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

    if (response.statusCode == 201) {
      // registo OK -> fazer login automático
      return await loginUser(email: email, password: password);
    } else {
      print('Register user falhou: ${response.statusCode} ${response.body}');
      return false;
    }
  }

  // -------------------------
  // REGISTER INSTITUTION (ADMIN)
  // -------------------------
  // Cria a conta de instituição; a validação do código faz-se depois
  // Retorna true se a criação tiver sucesso
  static Future<bool> registerAdmin({
    required String email,
    required String password,
    required String endereco,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register/admin'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
        'endereco': endereco,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      print('Register admin falhou: ${response.statusCode} ${response.body}');
      return false;
    }
  }

  // -------------------------
  // VALIDATE ADMIN (código)
  // -------------------------
  // Valida o código da instituição. Não faz login automaticamente (pode-se fazer)
  // Retorna true se o código for aceite
  static Future<bool> validateAdmin({
    required String email,
    required String code,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/validate-admin'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'code': code,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Validate admin falhou: ${response.statusCode} ${response.body}');
      return false;
    }
  }
}