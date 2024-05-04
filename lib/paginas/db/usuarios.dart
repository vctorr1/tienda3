import 'package:firebase_database/firebase_database.dart';

class UserServices {
  FirebaseDatabase _database = FirebaseDatabase.instance;
  String ref = "usuarios";

  createUser(Map value) {
    _database
        .ref()
        .child(ref)
        .push()
        .set(value)
        .catchError((e) => {print(e.toString())});
  }
}
