import 'dart:convert';
import 'package:cobaauth/models/user_model.dart';
import 'package:http/http.dart' as http;
import '../models/token_model.dart';
import '../services/auth_service.dart'; // Import your AuthService

abstract class AuthRepository {
  Future<Token> login(String username, String password);
  Future<Token> register(UserModel user);
}

class AuthRepositoryImpl implements AuthRepository {
  final http.Client client;
  final AuthService authService; // Add AuthService dependency

  AuthRepositoryImpl({required this.client, required this.authService});

  @override
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

  @override
  Future<Token> register(UserModel user) async {
    final response = await client.post(
      Uri.parse('http://10.0.2.2:3000/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Token.fromJson(data);
    } else {
      throw Exception('Failed to register');
    }
  }
}
