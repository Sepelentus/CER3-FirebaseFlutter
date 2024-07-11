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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fechaNacimientoController = TextEditingController();
  
  final DateFormat _formatoFecha = DateFormat('dd/MM/yyyy');


  String? selectedPosicion;
  @override
  void dispose() {
    fechaNacimientoController.dispose();
    super.dispose();
  }
  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (fechaSeleccionada != null) {
      setState(() {
        fechaNacimientoController.text = _formatoFecha.format(fechaSeleccionada);
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
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.red,
                      thickness: 5,
                      endIndent: 20,
                      indent: 20,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var jugador = snapshot.data!.docs[index];
                      DateTime fechaNacimiento;
                      if (jugador['Fecha Nacimiento'] is String && jugador['Fecha Nacimiento'].isNotEmpty) {
                        try {
                          fechaNacimiento = DateFormat('dd/MM/yyyy').parse(jugador['Fecha Nacimiento']);
                        } catch (e) {
                          fechaNacimiento = DateTime.now();
                        }
                      } else if (jugador['Fecha Nacimiento'] is Timestamp) {
                        fechaNacimiento = jugador['Fecha Nacimiento'].toDate();
                      } else {
                        fechaNacimiento = DateTime.now();
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
                                    'Fecha de Nacimiento: '  + _formatoFecha.format(fechaNacimiento), style: TextStyle(fontSize:15, color: Colors.white, fontWeight: FontWeight.bold),),

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
                String dorsal = '';
                String fechaNacimiento = '';
                return AlertDialog(
                  title: Text('Agregar Jugador'),
                  content: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                          ),
                          onChanged: (value) {
                            nombre = value;
                              },
                              validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el nombre';
                              }
                              if (value.length < 3) {
                                return 'El nombre debe tener al menos 3 caracteres';
                              }

                              if (value.length > 50) {
                                return 'El nombre debe tener menos de 50 caracteres';
                              }
                              if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                                return 'El nombre solo puede contener letras y espacios';
                              }
                              if (value.contains('  ')) {
                                return 'El nombre no puede contener doble espacio';
                              }
                              if (value.trim().split(' ').length < 2) {
                                return 'El nombre debe tener al menos un apellido';
                              }
                              return null;
                            },
                        ),
                        //mostrar dropdown con posiciones de jugadores de futbol
                        DropdownButtonFormField<String>(
                            value: selectedPosicion,
                            hint: Text('Posición'),
                            items: <String>['Arquero', 'Defensa', 'Mediocampista', 'Delantero']
                                .map((String value) {
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor seleccione una posición';
                              }
                              return null;
                            },
                          ),
                    
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Dorsal',
                          ),
                          onChanged: (value) {
                            dorsal = value;
                          },
                          validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese el dorsal';
                              }
                              if (value.length < 1) {
                                return 'El dorsal debe tener al menos 1 caracter';
                              }
                              if (value.length > 2) {
                                return 'El dorsal debe tener menos de 2 caracteres';
                              }
                              if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                return 'El dorsal solo puede contener números';
                              }
                              if (int.parse(value) < 1) {
                                return 'El dorsal debe ser mayor a 0';
                              }
                              if (int.parse(value) > 99) {
                                return 'El dorsal debe ser menor a 100';
                              }
                              return null;
                            },
                        ),
                        //fecha de nacimiento
                        GestureDetector(
                          onTap: () => _seleccionarFecha(context),
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: fechaNacimientoController,
                              decoration: InputDecoration(
                                labelText: 'Fecha de Nacimiento',
                              ),
                              validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor seleccione la fecha de nacimiento';
                                  }
                                  if (value.length != 10) {
                                    return 'Por favor seleccione la fecha de nacimiento';
                                  }
                                  return null;
                                },
                              
                              
                            ),
                            
                          ),
                        ),
                        
                    
                        
                      ],
                    ),
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
                        if (_formKey.currentState!.validate()) {
                          fechaNacimiento = fechaNacimientoController.text;
                          Navigator.of(context).pop();
                          // Agregar jugador
                          FirestoreService().addJugador(
                            nombre,
                            selectedPosicion ?? '',
                            dorsal,
                            fechaNacimiento,
                          );
                        }
                      },
                    ),
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
