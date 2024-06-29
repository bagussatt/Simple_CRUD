import 'package:cobaauth/repository/auth_repository.dart';
import 'package:cobaauth/screen/home_page.dart';
import 'package:flutter/material.dart';
import '../models/token_model.dart';

class LoginController {
  final AuthRepository authRepository;

  LoginController({required this.authRepository});

  Future<void> login(
      BuildContext context, String username, String password) async {
    try {
      Token token = await authRepository.login(username, password);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage(token: token.token)),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed')),
      );
    }
  }
}
