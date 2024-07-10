import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  // Obtener lista de jugadores
  Stream<QuerySnapshot> jugadores(){
    return FirebaseFirestore.instance.collection('jugadores').snapshots();
  }
  // Obtener lista de copas
  Stream<QuerySnapshot> copas(){
    return FirebaseFirestore.instance.collection('copas').snapshots();
  }

  void deleteJugador(String id) async {
    await FirebaseFirestore.instance.collection('jugadores').doc(id).delete();
  }

  void addJugador(String nombre, String arquero) async {
    await FirebaseFirestore.instance.collection('jugadores').add({
      'nombre': nombre,
      'arquero': arquero,
    });
  }
}


