import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda3/paginas/helpers/common.dart';
import 'package:tienda3/paginas/helpers/style.dart';
import 'package:tienda3/paginas/provider/user.dart';
import 'package:tienda3/widgets/loading.dart';
import 'package:tienda3/paginas/view/inicio.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool hidePass = true; // Para alternar la visibilidad de la contraseña
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: _scaffoldKey, // Uso del scaffoldKey
      body: userProvider.status == Status.Authenticating
          ? Loading() // Indicador de carga durante la autenticación
          : _buildSignUpForm(context, userProvider),
    );
  }

  Widget _buildSignUpForm(BuildContext context, UserProvider userProvider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding para consistencia
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //_buildLogo(), // Logo de la aplicación
              _buildNameField(), // Campo para el nombre
              _buildEmailField(), // Campo para el correo electrónico
              _buildPasswordField(), // Campo para la contraseña
              _buildSignUpButton(
                  context, userProvider), // Botón para registrarse
              _alreadyHaveAccount(), // Opción para usuarios existentes
            ],
          ),
        ),
      ),
    );
  }

  /*Widget _buildLogo() {
    return Image.asset(
      'images/logo.png',
      width: 260.0,
    );
  }*/

  Widget _buildNameField() {
    return _buildTextField(
      controller: _name,
      hintText: "Full Name",
      icon: Icons.person_outline,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "The name field cannot be empty";
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return _buildTextField(
      controller: _email,
      hintText: "Email",
      icon: Icons.alternate_email,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "The email field cannot be empty";
        }
        final emailPattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        final regex = RegExp(emailPattern);
        if (!regex.hasMatch(value)) {
          return "Please make sure your email address is valid";
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return _buildTextField(
      controller: _password,
      hintText: "Password",
      icon: Icons.lock_outline,
      obscureText: hidePass,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "The password field cannot be empty";
        }
        if (value.length < 6) {
          return "The password must be at least 6 characters long";
        }
        return null;
      },
      trailing: IconButton(
        icon: Icon(
          hidePass
              ? Icons.visibility_off
              : Icons.visibility, // Corrección: Crear un Icon
        ),
        onPressed: () {
          setState(() {
            hidePass = !hidePass; // Alterna la visibilidad de la contraseña
          });
        },
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context, UserProvider userProvider) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.black,
        child: MaterialButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final success = await userProvider.signUp(
                _name.text,
                _email.text,
                _password.text,
              );

              if (!success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  // Uso de ScaffoldMessenger
                  const SnackBar(
                      content: Text("Sign-up failed")), // SnackBar constante
                );
                return; // Devuelve para salir de la función si el registro falló
              }

              changeScreenReplacement(
                  context, HomePage()); // Navega a la página de inicio
            }
          },
          child: const Text(
            "Sign Up",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _alreadyHaveAccount() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context); // Regresar a la pantalla anterior
        },
        child: const Text(
          "I already have an account",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    required FormFieldValidator<String> validator,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: ListTile(
            title: TextFormField(
              controller: controller,
              obscureText: obscureText,
              decoration: InputDecoration(
                hintText: hintText,
                icon: Icon(icon),
                border: InputBorder.none,
              ),
              validator: validator,
            ),
            trailing:
                trailing, // Para el icono de alternancia en el campo de contraseña
          ),
        ),
      ),
    );
  }
}
