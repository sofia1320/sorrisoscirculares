// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:3000';
  
  // Storage for authentication token and user data
  static String? _authToken;
  static Map<String, dynamic>? _userData;
  
  // Getters for authentication state
  static String? get authToken => _authToken;
  static Map<String, dynamic>? get userData => _userData;
  static bool get isAuthenticated => _authToken != null;
  
  // login utilizador
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
        _authToken = data['token'];
        _userData = data['user'];
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  //registo utilizador
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
        final data = json.decode(response.body);
        _authToken = data['token'];
        _userData = data['user'];
        return true;
      }
      return false;
    } catch (e) {
      print('Register error: $e');
      return false;
    }
  }
  
  // Criar doação
  static Future<Map<String, dynamic>?> createDonation({
    required String childId,
    required DateTime dateTime,
  }) async {
    if (!isAuthenticated) {
      print('User not authenticated');
      return null;
    }
    
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/donations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
        body: json.encode({
          'childId': childId,
          'dateTime': dateTime.toIso8601String(),
        }),
      );
      
      if (response.statusCode == 201) {
        return json.decode(response.body);
      }
      print('Create donation failed: ${response.statusCode}');
      return null;
    } catch (e) {
      print('Create donation error: $e');
      return null;
    }
  }
  
  // Obter doações do utilizador
  static Future<List<Map<String, dynamic>>> getDonations() async {
    if (!isAuthenticated) {
      print('User not authenticated');
      return [];
    }
    
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/donations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      }
      print('Get donations failed: ${response.statusCode}');
      return [];
    } catch (e) {
      print('Get donations error: $e');
      return [];
    }
  }
  
  // Logout
  static void logout() {
    _authToken = null;
    _userData = null;
  }
}