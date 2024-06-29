import 'dart:convert';
import 'package:cobaauth/models/user_model.dart';
import 'package:cobaauth/models/token_model.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final http.Client client;

  AuthService({required this.client});

  Future<Token> login(String username, String password) async {
    final response = await client.post(
      Uri.parse('http://10.0.2.2:3000/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Token.fromJson(data);
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<bool> register(UserModel user) async {
    try {
      final response = await client.post(
        Uri.parse('http://your_api/register'), // Replace with your registration endpoint
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        return true; // Registration successful
      } else {
        return false; // Registration failed
      }
    } catch (e) {
      print('Error registering user: $e');
      return false; // Registration failed
    }
  }
}
