import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda3/paginas/model/auth_service.dart';
import 'package:tienda3/paginas/view/signup_screen.dart';
import 'package:tienda3/paginas/view/inicio.dart';
import 'package:tienda3/widgets/button.dart';
import 'package:tienda3/widgets/textfield.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  late SharedPreferences preferencias;

  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const Spacer(),
            const Text("Iniciar Sesión",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
            const SizedBox(height: 50),
            CustomTextField(
              hint: "Introduzca su email",
              label: "Email",
              controller: _email,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Introduzca una contraseña",
              label: "Contraseña",
              controller: _password,
            ),
            const SizedBox(height: 30),
            CustomButton(
              label: "Iniciar Sesión",
              onPressed: _login,
            ),
            const SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("No tienes cuenta? "),
              InkWell(
                onTap: () => goToSignup(context),
                child: const Text("Registrarme",
                    style: TextStyle(color: Colors.red)),
              )
            ]),
            const Spacer()
          ],
        ),
      ),
    );
  }

  goToSignup(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignupScreen()),
      );

  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );

  _login() async {
    final user =
        await _auth.loginUserWithEmailAndPassword(_email.text, _password.text);
    preferencias = await SharedPreferences.getInstance();
    if (user != null) {
      log("Sesión iniciada");
      goToHome(context);
    }
  }
}
