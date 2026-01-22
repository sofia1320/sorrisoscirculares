// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ApiService {
  // Use 10.0.2.2 for Android emulator to access localhost
  // For iOS simulator, use 127.0.0.1
  // For physical devices, use your machine's IP address
  static const String baseUrl = 'http://10.0.2.2:3000';

  // Register user - POST /auth/register
  // On 201, automatically calls loginUser to save token and user
  static Future<bool> registerUser({
    required String nome,
    required String email,
    required String password,
    required String telemovel,
  }) async {
    try {
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
        // Auto-login after successful registration
        return await loginUser(email: email, password: password);
      }
      return false;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  // Register admin - POST /auth/register/admin
  // Returns true if 201
  static Future<bool> registerAdmin({
    required String email,
    required String password,
    required String endereco,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/admin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'endereco': endereco,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Error registering admin: $e');
      return false;
    }
  }

  // Validate admin - POST /auth/validate-admin
  // Returns true if 200
  static Future<bool> validateAdmin({
    required String email,
    required String code,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/validate-admin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'code': code,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error validating admin: $e');
      return false;
    }
  }

  // Login user - POST /auth/login
  // On 200, saves token and user to SharedPreferences
  static Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        
        // Save token
        if (data['token'] != null) {
          await prefs.setString('token', data['token']);
        }
        
        // Save user data
        if (data['user'] != null) {
          await prefs.setString('user', json.encode(data['user']));
        }
        
        return true;
      }
      return false;
    } catch (e) {
      print('Error logging in: $e');
      return false;
    }
  }
}