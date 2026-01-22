// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Base URL - adjust for your platform:
  // Android Emulator: http://10.0.2.2:3000
  // iOS Simulator: http://localhost:3000
  // Physical Device: http://<YOUR_IP>:3000
  static const String baseUrl = 'http://10.0.2.2:3000';

  // Register user and automatically login (store JWT + user)
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
        final data = json.decode(response.body);
        if (data['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', data['token']);
          if (data['user'] != null) {
            await prefs.setString('user_data', json.encode(data['user']));
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

  // Register admin (institution)
  static Future<bool> registerAdmin({
    required String nome,
    required String email,
    required String password,
    required String morada,
    required String nif,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register/admin'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': nome,
          'email': email,
          'password': password,
          'morada': morada,
          'nif': nif,
        }),
      );
      return response.statusCode == 201;
    } catch (e) {
      print('Error registering admin: $e');
      return false;
    }
  }

  // Validate admin with code
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

  // Login user and store JWT + user data
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
        if (data['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', data['token']);
          if (data['user'] != null) {
            await prefs.setString('user_data', json.encode(data['user']));
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error logging in: $e');
      return false;
    }
  }

  // Get stored JWT token
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('jwt_token');
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  // Logout user (clear stored data)
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');
      await prefs.remove('user_data');
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}
