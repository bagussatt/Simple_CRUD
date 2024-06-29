import 'package:cobaauth/controllers/auth_controller.dart';
import 'package:cobaauth/repository/auth_repository.dart';
import 'package:cobaauth/screen/register_page.dart';
import 'package:cobaauth/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late LoginController _loginController; // Removed initialization here

  @override
  void initState() {
    super.initState();
    _loginController = LoginController(
        authRepository: AuthRepositoryImpl(
            client: http.Client(),
            authService: AuthService(client: http.Client())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _loginController.login(
                  context,
                  _usernameController.text,
                  _passwordController.text,
                );
              },
              child: Text('Login'),
            ),
            SizedBox(height: 10), // Spacing between buttons
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(
                        authController: AuthController(
                            repository: AuthRepositoryImpl(
                                client: http.Client(),
                                authService:
                                    AuthService(client: http.Client())))),
                  ),
                );
                if (result != null && result is String) {
                  // If registration was successful, update the username field
                  _usernameController.text = result;
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
