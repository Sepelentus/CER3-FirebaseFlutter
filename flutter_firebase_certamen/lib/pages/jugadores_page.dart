import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_certamen/services/firestore_services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class JugadoresPage extends StatefulWidget {
  const JugadoresPage({super.key});

  @override
  State<JugadoresPage> createState() => _JugadoresPageState();
}

class _JugadoresPageState extends State<JugadoresPage> {
  @override
  Widget build(BuildContext context) {
    String selectedPosicion = 'Delantero';
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 0, 2, 3),
          title: Text(
              style: TextStyle(color: Colors.white), 'Jugadores del equipo'),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Wallp.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: StreamBuilder(
              stream: FirestoreService().jugadores(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                // Espera de datos
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  // Datos recibidos
                  return ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var jugador = snapshot.data!.docs[index];
                      return ListTile(
                          leading: Icon(MdiIcons.account),
                          title: Text(
                          'Nombre: ${jugador['Nombre ']} \nPosicion: ${jugador['Posicion']} Dorsal: ${jugador['Dorsal']}'),
                          subtitle: Text('${jugador['Fecha Nacimiento']}'),

                          //eliminar jugador
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Eliminar Jugador'),
                                      content: Text(
                                          '¿Está seguro de eliminar a ${jugador['Nombre ']}?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Cancelar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('Eliminar'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            // Eliminar jugador
                                            FirestoreService()
                                                .deleteJugador(jugador.id);
                                          },
                                        )
                                      ],
                                    );
                                  });
                            },
                          ));
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),

      //boton agregar jugador
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                String nombre = '';
                String posicion = '';
                String dorsal = '';
                String fechaNacimiento = '';
                return AlertDialog(
                  title: Text('Agregar Jugador'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Nombre',
                        ),
                        onChanged: (value) {
                          nombre = value;
                        },
                      ),
                      DropdownButton<String>(
                        value: selectedPosicion,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPosicion = newValue!;
                            posicion = newValue; 
                          });
                        },
                        items: <String>['Delantero', 'Defensa', 'Portero', 'Mediocampo']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      //dorsal
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Dorsal',
                        ),
                        onChanged: (value) {
                          dorsal = value;
                        },
                      ),
                      //fecha de nacimiento
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Fecha de Nacimiento',
                        ),
                        onChanged: (value) {
                          fechaNacimiento = value;
                        },
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Cancelar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Agregar'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Agregar jugador
                        FirestoreService().addJugador(nombre, posicion, dorsal, fechaNacimiento);
                      },
                    )
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
