import 'dart:developer';

import 'package:tienda3/paginas/db/auth_service.dart';
import 'package:tienda3/paginas/auth/login_screen.dart';
import 'package:tienda3/paginas/db/usuarios.dart';
import 'package:tienda3/paginas/inicio.dart';
import 'package:tienda3/widgets/button.dart';
import 'package:tienda3/widgets/textfield.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService();
  //UserServices _userServices = UserServices();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
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
            const Text("Registro",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500)),
            const SizedBox(
              height: 50,
            ),
            CustomTextField(
              hint: "Introduce tu nombre",
              label: "Nombre",
              controller: _name,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "introduce tu email",
              label: "Email",
              controller: _email,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hint: "Introduce tu contraseña",
              label: "Contraseña",
              isPassword: true,
              controller: _password,
            ),
            const SizedBox(height: 30),
            CustomButton(
              label: "Registrarme",
              onPressed: _signup,
            ),
            const SizedBox(height: 5),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Ya tienes cuenta? "),
              InkWell(
                onTap: () => goToLogin(context),
                child: const Text("Iniciar Sesión",
                    style: TextStyle(color: Colors.red)),
              )
            ]),
            const Spacer()
          ],
        ),
      ),
    );
  }

  goToLogin(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );

  goToHome(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );

  _signup() async {
    final user = await _auth.createUserWithEmailAndPassword(
        _email.text, _password.text, _name.text);
    if (user != null) {
      log("Usuario creado con exito");
      goToHome(context);
    }
  }
}
