import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const _baseUrl = 'https://training-api-unrp.onrender.com';

  /// Gọi API POST /login với body {taxId, username, password}
  /// Trả về Map<String, dynamic> decode từ JSON.
  static Future<Map<String, dynamic>> login({
    required String taxCode,
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/login2');
    final body = jsonEncode({
      'tax_code': int.parse(taxCode),
      'user_name': username,
      'password': password,
    });
    debugPrint('→ POST $uri');
    debugPrint('  headers: {"Content-Type":"application/json"}');
    debugPrint('  body: $body');
    try {
      final resp = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      debugPrint('← status: ${resp.statusCode}');
      debugPrint('← body: ${resp.body}');
      if (resp.statusCode == 200) {
        return jsonDecode(resp.body);
      } else {
        throw Exception('Server error (${resp.statusCode})');
      }
    } catch (e, st) {
      debugPrint('!!! Exception when POST: $e');
      debugPrint('$st');
      rethrow;
    }
  }
}
