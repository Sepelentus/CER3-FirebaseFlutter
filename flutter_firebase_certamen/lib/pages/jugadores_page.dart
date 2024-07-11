import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_certamen/services/firestore_services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';

class JugadoresPage extends StatefulWidget {
  const JugadoresPage({super.key});

  @override
  State<JugadoresPage> createState() => _JugadoresPageState();
}

class _JugadoresPageState extends State<JugadoresPage> {
  final TextEditingController _fechaNacimientoController = TextEditingController();
  
  final DateFormat _formatoFecha = DateFormat('dd/MM/yyyy');


  String? selectedPosicion;
  @override
  void dispose() {
    _fechaNacimientoController.dispose();
    super.dispose();
  }
  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (fechaSeleccionada != null) {
      setState(() {
        _fechaNacimientoController.text = _formatoFecha.format(fechaSeleccionada);
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 0, 2, 3),
          title: Text(
              style: TextStyle(color: Colors.white), 'JUGADORES DEL EQUIPO'),
          titleTextStyle: TextStyle(
            fontFamily: 'Outfit',
            fontSize: 22,
            letterSpacing: 3,
          ),
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
                      
                      DateTime fechaNacimiento;
                      if (jugador['Fecha Nacimiento'] is String && jugador['Fecha Nacimiento'].isNotEmpty) {
                        try {
                          fechaNacimiento = DateFormat('dd/MM/yyyy').parse(jugador['Fecha Nacimiento']);
                          
                        } catch (e) {
                          // Manejo de error o asignación de una fecha predeterminada
                          fechaNacimiento = DateTime.now(); 
// O cualquier fecha predeterminada
                          // Opcional: mostrar un mensaje de error o log
                        }
                      } else if (jugador['Fecha Nacimiento'] is Timestamp) {
                        // Si 'Fecha Nacimiento' es un Timestamp, lo convierte directamente a DateTime
                        fechaNacimiento = jugador['Fecha Nacimiento'].toDate();
                        

                      } else {
                        // Manejo de casos inesperados o asignación de una fecha predeterminada
                        fechaNacimiento = DateTime.now();
 // O cualquier fecha predeterminada
                        // Opcional: mostrar un mensaje de error o log
                      }
                      return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26)),
                          margin: EdgeInsets.all(5),
                          elevation: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                
                                image: AssetImage("assets/images/cardwall.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: ListTile(
                                leading: Icon(
                                  MdiIcons.account,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                
                                title: Text(
                                    'Nombre: ${jugador['Nombre ']} \nPosicion: ${jugador['Posicion']} \nDorsal: ${jugador['Dorsal']}', style: TextStyle(fontSize: 15 ,color: Colors.white, fontWeight: FontWeight.bold),),
                                subtitle: Text(
                                    'Fecha de Nacimiento: '  + fechaNacimiento.toString(), style: TextStyle(fontSize:15, color: Colors.white, fontWeight: FontWeight.bold),),

                                //eliminar jugador
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red,),
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
                                                      .deleteJugador(
                                                          jugador.id);
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  },
                                )),
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
        elevation: 4,
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                String? selectedPosicion;
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
                      //mostrar dropdown con posiciones de jugadores de futbol
                      DropdownButton<String>(
                        value: selectedPosicion,
                        hint: Text('Posicion'),
                        items: <String>[
                          'Arquero',
                          'Defensa',
                          'Mediocampista',
                          'Delantero'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPosicion = newValue!;
                          });
                        },
                      ),

                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Dorsal',
                        ),
                        onChanged: (value) {
                          dorsal = value;
                        },
                      ),
                      //fecha de nacimiento
                      GestureDetector(
                        onTap: () => _seleccionarFecha(context),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: _fechaNacimientoController,
                            decoration: InputDecoration(
                              labelText: 'Fecha de Nacimiento',
                            ),
                          ),
                        ),
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
                        FirestoreService().addJugador(
                            nombre, posicion, dorsal, fechaNacimiento);
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
