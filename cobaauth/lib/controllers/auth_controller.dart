// controllers/auth_controller.dart

import 'package:cobaauth/repository/auth_repository.dart';
import '../models/user_model.dart';
import '../models/token_model.dart';

class AuthController {
  final AuthRepository repository;

  AuthController({required this.repository});

  Future<Token> register(UserModel user) async {
    try {
      return await repository.register(user);
    } catch (e) {
      rethrow; // Handle errors as needed
    }
  }
}
