import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tienda3/paginas/db/usuarios.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  late SharedPreferences preferencias;

  //Instancia de userServices
  final UserServices _userServices = UserServices();

  Future<User?> createUserWithEmailAndPassword(
      String email, String password, String nombre) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      //Llamar a createUserInFirestore después de la creación del usuario
      await createUserInFirestore(cred.user!, nombre);
      await createUserInRealtimeDatabase(cred.user!, nombre);
      return cred.user;
    } catch (e) {
      log("Ocurrió un error al registrar usuario: $e");
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      //Llamar a createUserInFirestore después de la creación del usuario
      if (cred.user != null) {
        // Llamar a createUserInFirestore después de un inicio de sesión exitoso
      }
      return cred.user;
    } catch (e) {
      log("Ocurrio un error al iniciar sesión: $e");
    }
    return null;
  }

  //Metodo para crear el usuario en firestore
  Future<void> createUserInFirestore(User user, String nombre) async {
    try {
      // Verificar si ya existe un documento para este usuario
      final QuerySnapshot resultado = await FirebaseFirestore.instance
          .collection("usuarios")
          .where("id", isEqualTo: user.uid)
          .get();
      final List<DocumentSnapshot> documentos = resultado.docs;

      if (documentos.isEmpty) {
        // Si no existe, crear un nuevo documento con campos vacíos
        await FirebaseFirestore.instance
            .collection("usuarios")
            .doc(user.uid)
            .set({
          "id": user.uid,
          "usuario": nombre, // Campo vacío
          "fotoPerfil": "", // Campo vacío
        });
      }
    } catch (e) {
      log("Error crendo usuario en Firestore: $e");
    }
  }

  Future<void> createUserInRealtimeDatabase(User user, nombre) async {
    try {
      final uid = user.uid;
      final data = {
        "id": uid,
        "email": user.email,
        "displayName": nombre,
        "photoURL": user.photoURL ?? "",
      };

      _userServices.createUser(uid, data); // Llamada para crear el usuario
    } catch (e) {
      log("Error creando usuario en Realtime Database: $e");
    }
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log("Ocurrio un error al cerrar sesión: $e");
    }
  }
}
