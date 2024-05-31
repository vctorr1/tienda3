import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tienda3/paginas/provider/user.dart';
import 'package:tienda3/paginas/view/inicio.dart';
import 'package:tienda3/widgets/loading.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  bool hidePass = true; // Control para alternar visibilidad de contraseña
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: ScaffoldMessenger(
        key: _scaffoldMessengerKey, // Para manejar SnackBars
        child: userProvider.status == Status.Authenticating
            ? Loading() // Mostrar indicador de carga
            : Center(
                // Centrar contenido en la pantalla
                child: SingleChildScrollView(
                  // Permite desplazamiento si es necesario
                  child: Padding(
                    padding: const EdgeInsets.all(
                        16.0), // Consistencia en el padding
                    child: _buildSignUpForm(
                        context, userProvider), // Construir el formulario
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSignUpForm(BuildContext context, UserProvider userProvider) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
        children: <Widget>[
          _buildNameField(),
          _buildEmailField(),
          _buildPasswordField(),
          _buildSignUpButton(context, userProvider), // Botón de registro
          _alreadyHaveAccount(), // Texto para usuarios existentes
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return _buildTextField(
      controller: _name,
      hintText: "Nombre completo",
      icon: Icons.person_outline,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "El campo no puede estar vacío";
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return _buildTextField(
      controller: _email,
      hintText: "Correo electrónico",
      icon: Icons.alternate_email,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "El email no puede estar vacío";
        }
        final emailPattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        final regex = RegExp(emailPattern);
        if (!regex.hasMatch(value)) {
          return "Por favor, ingrese un email válido";
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
      obscureText: hidePass, // Control de visibilidad
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "La contraseña no puede estar vacía";
        }
        if (value.length < 6) {
          return "La contraseña debe tener al menos 6 caracteres";
        }
        return null;
      },
      trailing: IconButton(
        icon: Icon(
          hidePass ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: () {
          setState(() {
            hidePass = !hidePass; // Alternar visibilidad de contraseña
          });
        },
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context, UserProvider userProvider) {
    return Padding(
      padding: const EdgeInsets.all(16), // Espacio entre campos
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
                _scaffoldMessengerKey.currentState?.showSnackBar(
                  const SnackBar(content: Text("El registro falló")),
                );
                return;
              }

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomePage()), // Cambia a la pantalla de inicio
              );
            }
          },
          child: const Text(
            "Registrarme",
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

  Widget _alreadyHaveAccount() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context); // Regresar a la pantalla anterior
        },
        child: const Text(
          "Ya tengo cuenta",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
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
                border: InputBorder.none, // Sin borde visible
              ),
              validator: validator,
            ),
            trailing: trailing, // Para el icono adicional
          ),
        ),
      ),
    );
  }
}
