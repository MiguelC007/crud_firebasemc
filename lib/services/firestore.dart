import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference usuarios = FirebaseFirestore.instance.collection('usuarios');

  Future<void> addUsuario(String usuario, String telefono, String numeroIdentidad, String ciudad) {
    return usuarios.add({
      'usuario': usuario,
      'telefono': telefono,
      'numeroIdentidad': numeroIdentidad,
      'ciudad': ciudad,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getUsuariosStream() {
    final usuariosStream = usuarios.orderBy('timestamp', descending: true).snapshots();
    return usuariosStream;
  }

  Future<void> updateUsuario(String docID, String usuario, String telefono, String numeroIdentidad, String ciudad) {
    return usuarios.doc(docID).update({
      'usuario': usuario,
      'telefono': telefono,
      'numeroIdentidad': numeroIdentidad,
      'ciudad': ciudad,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteUsuario(String docID) {
    return usuarios.doc(docID).delete();
  }
}
