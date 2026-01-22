// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ApiService {
  // Base URL for API - using 10.0.2.2 for Android emulator
  // For iOS simulator use 127.0.0.1 or localhost
  // For physical devices use your computer's IP address
  static const String baseUrl = 'http://10.0.2.2:3000';

  // Helper method to save token and user data
  static Future<void> _saveAuthData(String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('user', json.encode(user));
  }

  // Helper method to get token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Helper method to get user data
  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('user');
    if (userStr != null) {
      try {
        return json.decode(userStr) as Map<String, dynamic>;
      } catch (e) {
        print('Error decoding user data: $e');
        return null;
      }
    }
    return null;
  }

  // Helper method to clear auth data (logout)
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }

  // Register User - POST /auth/register
  // On success (201), automatically login to save token and user data
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
        // Registration successful, now login to get token
        return await loginUser(email: email, password: password);
      }
      return false;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  // Register Admin - POST /auth/register/admin
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

  // Validate Admin - POST /auth/validate-admin
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

  // Login User - POST /auth/login
  // On success (200), save token and user data in SharedPreferences
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
        final data = json.decode(response.body) as Map<String, dynamic>;
        
        // Validate response structure
        if (!data.containsKey('token') || !data.containsKey('user')) {
          print('Invalid response structure: missing token or user');
          return false;
        }
        
        final token = data['token'] as String?;
        final user = data['user'] as Map<String, dynamic>?;
        
        if (token == null || user == null) {
          print('Invalid response: token or user is null');
          return false;
        }
        
        await _saveAuthData(token, user);
        return true;
      }
      return false;
    } catch (e) {
      print('Error logging in: $e');
      return false;
    }
  }
}
