import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_certamen/services/firestore_services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';


class CopasPage extends StatefulWidget {
  const CopasPage({super.key});

  @override
  State<CopasPage> createState() => _CopasState();
}

class _CopasState extends State<CopasPage> {
  final _formKey = GlobalKey<FormState>();
    final TextEditingController fechaNacimientoController = TextEditingController();
    final TextEditingController equipo1Controller = TextEditingController();
final TextEditingController equipo2Controller = TextEditingController();

  
  final DateFormat _formatoFecha = DateFormat('dd/MM/yyyy');

  void dispose() {
    fechaNacimientoController.dispose();
      equipo1Controller.dispose();
  equipo2Controller.dispose();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/TUNEL.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              title: Text(
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), 'COPAS GANADAS'),
              titleTextStyle: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 22,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/B.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: StreamBuilder(
              stream: FirestoreService().copas(), 
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                // Espera de datos
                if(!snapshot.hasData || snapshot.connectionState==ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }else{
                  // Datos recibidos
                  return ListView.separated(
                    separatorBuilder: (context,index)=>Divider(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      var copas = snapshot.data!.docs[index];
                      DateTime fechaNacimiento;
                      if (copas['Fecha'] is String && copas['Fecha'].isNotEmpty) {
                        try {
                          fechaNacimiento = DateFormat('dd/MM/yyyy').parse(copas['Fecha']);
                        } catch (e) {
                          fechaNacimiento = DateTime.now();
                        }
                      } else if (copas['Fecha'] is Timestamp) {
                        fechaNacimiento = copas['Fecha'].toDate();
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
                                
                                image: AssetImage("assets/images/banner.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                        child: ListTile(
                          leading: Icon(MdiIcons.trophy, color: Colors.amber, size: 40,),
                          title: Text('${copas['Nombre Titulo']} \nFecha: ' + _formatoFecha.format(fechaNacimiento) , style: TextStyle(fontSize: 15 ,color: Colors.white, fontWeight: FontWeight.bold),),
                          subtitle: Text('${copas['Ultimo Partido']}', style: TextStyle(fontSize:15, color: Colors.white, fontWeight: FontWeight.bold),),

                          //eliminar copa
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red, size: 20,),
                                onPressed: (){
                                  showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Eliminar Copa'),
                                                content: Text(
                                                    '¿Está seguro de eliminar ${copas['Nombre Titulo']}?'),
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
                                                          .deleteCopa(
                                                              copas.id);
                                                    },
                                                  )
                                                ],
                                              );
                                            });
                                },
                              ),
                              //mostrar datos curiosos
                              IconButton(
                                icon: Icon(Icons.info, color: Colors.white, size: 20,),
                                onPressed: (){
                                  showDialog(
                                    context: context,
                                    builder: (context){
                                      return AlertDialog(
                                        title: Text('Datos Curiosos'),
                                        content: Text('${copas['Datos Curiosos']}'),
                                        actions: [
                                          TextButton(
                                            child: Text('Cerrar'),
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    }
                                  );
                                },
                              ),
                            ],
                          )
                        ),
                          )
                      );
                    },
                    
                    );
                }
              },
            ),
          ),
        ],
      ),

      //boton para añadir copas
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        foregroundColor: const Color.fromARGB(255, 255, 238, 0),
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        onPressed: (){
        showDialog(
          context: context,
          builder: (context){
            String nombre_titulo = '';
            List<String> ultimo_partido = [];
            String fechaNacimiento = '';

            String datos = '';

            return AlertDialog(
              title: Text('Añadir Copa'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Nombre de la Copa'),
                      onChanged: (value){
                        nombre_titulo = value;
                      },
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Por favor ingrese el nombre de la copa';
                        }
                        if(value.length < 3){
                          return 'El nombre de la copa debe tener al menos 3 caracteres';
                        }
                        if(value.length > 50){
                          return 'El nombre de la copa debe tener menos de 50 caracteres';
                        }
                        if(value.contains(RegExp(r'[0-9]'))){
                          return 'El nombre de la copa no puede contener números';
                        }
                        if(value.contains(RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]'))){
                          return 'El nombre de la copa no puede contener caracteres especiales';
                        }
                        return null;
                      },
                    
                    ),
                    TextFormField(
                      controller: equipo1Controller,
                      decoration: InputDecoration(hintText: 'Equipo local'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el primer equipo';
                        }
                        if (value.length < 3) {
                          return 'El nombre del equipo debe tener al menos 3 caracteres';
                        }
                        if (value.length > 50) {
                          return 'El nombre del equipo debe tener menos de 50 caracteres';
                        }
                        if (value.contains(RegExp(r'[0-9]'))) {
                          return 'El nombre del equipo no puede contener números';
                        }
                        if (value == equipo2Controller.text) {
                          return 'El nombre del equipo 2 no puede ser igual al nombre del equipo 1';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: equipo2Controller,
                      decoration: InputDecoration(hintText: 'Equipo visita'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el segundo equipo';
                        }
                        if (value.length < 3) {
                          return 'El nombre del equipo debe tener al menos 3 caracteres';
                        }
                        if (value.length > 50) {
                          return 'El nombre del equipo debe tener menos de 50 caracteres';
                        }
                        if (value.contains(RegExp(r'[0-9]'))) {
                          return 'El nombre del equipo no puede contener números';
                        }
                        
                        if (value == equipo1Controller.text) {
                          return 'El nombre del equipo 2 no puede ser igual al nombre del equipo 1';
                        }
                        return null;
                      },
                    ),
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

                    TextFormField(
                      decoration: InputDecoration(hintText: 'Datos'),
                      onChanged: (value){
                        datos = value;
                      },
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return 'Por favor ingrese un dato historico';
                        }
                        if(value.length < 3){
                          return 'Los datos deben tener al menos 3 caracteres';
                        }
                        if(value.length > 1000){
                          return 'Los datos deben tener menos de 1000 caracteres';
                        }
                        if(value.contains(RegExp(r'[0-9]'))){
                          return 'Los datos no pueden contener números';
                        }
                        
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  
                ),
                TextButton(
                  child: Text('Añadir'),
                  onPressed: (){
                    if(!_formKey.currentState!.validate()){
                    fechaNacimiento = fechaNacimientoController.text;
                    ultimo_partido.add(equipo1Controller.text);
                    ultimo_partido.add(equipo2Controller.text);
                    Navigator.pop(context);
                    FirestoreService().addCopa(nombre_titulo, ultimo_partido, fechaNacimiento, datos);
                    }
                  },
                  
                ),
              ],
            );
          },
        );
      },
      child: Icon(Icons.add),
      )
    );
  }
}