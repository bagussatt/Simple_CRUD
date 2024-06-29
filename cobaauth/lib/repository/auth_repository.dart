import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/token_model.dart';

abstract class AuthRepository {
  Future<Token> login(String username, String password);
}

class AuthRepositoryImpl implements AuthRepository {
  final http.Client client;

  AuthRepositoryImpl({required this.client});

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
}
