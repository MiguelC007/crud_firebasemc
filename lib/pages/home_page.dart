import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_firebasemc/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _textController = TextEditingController();

  void _openUsuarioBox({String? docID}) {
    String? usuario;
    String? telefono;
    String? numeroIdentidad;
    String? ciudad;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: usuario ?? ''),
              onChanged: (value) => usuario = value,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: TextEditingController(text: telefono ?? ''),
              onChanged: (value) => telefono = value,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            TextField(
              controller: TextEditingController(text: numeroIdentidad ?? ''),
              onChanged: (value) => numeroIdentidad = value,
              decoration: InputDecoration(labelText: 'Número de Identidad'),
            ),
            TextField(
              controller: TextEditingController(text: ciudad ?? ''),
              onChanged: (value) => ciudad = value,
              decoration: InputDecoration(labelText: 'Ciudad'),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                _firestoreService.addUsuario(
                  usuario ?? '',
                  telefono ?? '',
                  numeroIdentidad ?? '',
                  ciudad ?? '',
                );
              } else {
                _firestoreService.updateUsuario(
                  docID,
                  usuario ?? '',
                  telefono ?? '',
                  numeroIdentidad ?? '',
                  ciudad ?? '',
                );
              }
              _textController.clear();
              Navigator.pop(context);
            },
            child: Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Usuarios")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openUsuarioBox(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getUsuariosStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List usuariosList = snapshot.data!.docs;

            return ListView.builder(
              itemCount: usuariosList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = usuariosList[index];
                String docID = document.id;

                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String usuarioText = data['usuario'];

                return ListTile(
                  title: Text(usuarioText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => _openUsuarioBox(docID: docID),
                        icon: const Icon(Icons.settings),
                      ),
                      IconButton(
                        onPressed: () => _firestoreService.deleteUsuario(docID),
                        icon: const Icon(Icons.delete),
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return const Text("No usuarios..");
          }
        },
      ),
    );
  }
}


