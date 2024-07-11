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

  void addJugador(String nombre, String posicion, String dorsal, String fechaNacimiento) async {
    await FirebaseFirestore.instance.collection('jugadores').add({
      'Nombre ': nombre,
      'Posicion': posicion,
      'Dorsal': dorsal,
      'Fecha Nacimiento': fechaNacimiento,
    });
  }
void addCopa(String nombre_titulo, List<String> ultimo_partido, String fecha, String DatosCuriosos) async {
  await FirebaseFirestore.instance.collection('copas').add({
    'Nombre Titulo': nombre_titulo,
    'Ultimo Partido': ultimo_partido,
    'Fecha': fecha,
    'Datos Curiosos': DatosCuriosos,
  });
}

  void deleteCopa(String id) async{
    await FirebaseFirestore.instance.collection('copas').doc(id).delete();
  }
}


