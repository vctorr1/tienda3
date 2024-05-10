import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda3/paginas/helpers/style.dart';
import 'package:tienda3/paginas/provider/user.dart';
import 'package:tienda3/paginas/view/signup.dart';
import 'package:tienda3/widgets/loading.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      body: userProvider.status == Status.Authenticating
          ? Loading() // Indicador de carga
          : _buildLoginForm(context,
              userProvider), // Método para el formulario de inicio de sesión
    );
  }

  Widget _buildLoginForm(BuildContext context, UserProvider userProvider) {
    return Padding(
      padding: const EdgeInsets.all(16.0), // Padding consistente
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 40), // Espacio entre elementos
            _buildLogo(), // Método para cargar el logo
            _buildEmailField(), // Campo para el correo electrónico
            _buildPasswordField(), // Campo para la contraseña
            _buildLoginButton(userProvider), // Botón para iniciar sesión
            _buildOptionsRow(
                context), // Fila para opciones como "Olvidé mi contraseña"
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Align(
      alignment: Alignment.topCenter,
      child: Text(
        "Iniciar sesión",
      ),
    );
  }

  Widget _buildEmailField() {
    return _buildTextField(
      controller: _email,
      hintText: "Email",
      icon: Icons.alternate_email,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "El campo no puede estar vacío";
        }
        final emailPattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        final regex = RegExp(emailPattern);
        if (!regex.hasMatch(value)) {
          return 'Verifique el email introducido';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return _buildTextField(
      controller: _password,
      hintText: "Contraseña",
      icon: Icons.lock_outline,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "El campo no puede estar vacío";
        }
        if (value.length < 6) {
          return "La contraseña debe tener al menos 6 caracteres";
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton(UserProvider userProvider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Material(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.black,
        child: MaterialButton(
          onPressed: () async {
            if (_formKey.currentState?.validate() ?? false) {
              final success = await userProvider.signIn(
                _email.text,
                _password.text,
              );

              if (!success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Inicio de sesión falló")),
                );
              }
            }
          },
          child: const Text(
            "Iniciar sesión",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Olvide mi contraseña",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUp(),
                ),
              );
            },
            child: const Text(
              "Registrarme",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    required FormFieldValidator<String> validator,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      color: Colors.grey.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            icon: Icon(icon),
            border: InputBorder.none,
          ),
          validator: validator,
        ),
      ),
    );
  }
}
