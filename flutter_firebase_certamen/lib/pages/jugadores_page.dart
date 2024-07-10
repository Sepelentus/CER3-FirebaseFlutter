import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_certamen/services/firestore_services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class JugadoresPage extends StatelessWidget {
const JugadoresPage({ super.key });

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 0, 2, 3),
          title:Text(style: TextStyle(color: Colors.white ),
          'Jugadores del equipo'),
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
                      var jugador = snapshot.data!.docs[index];
                      return ListTile(
                        leading: Icon(MdiIcons.account),
                        title: Text('${jugador['nombre']}'),
                        subtitle: Text('${jugador['arquero']}'),
                        //eliminar jugador
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: (){
                            showDialog(context: context, builder: (BuildContext context){
                              return AlertDialog(
                                title: Text('Eliminar Jugador'),
                                content: Text('¿Está seguro de eliminar a ${jugador['nombre']}?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Cancelar'),
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Eliminar'),
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                      // Eliminar jugador
                                      FirestoreService().deleteJugador(jugador.id);
                                    },
                                  )
                                ],
                              );
                            });
                          },
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

      //boton agregar jugador
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context, builder: (BuildContext context){
            String nombre = '';
            String arquero = '';
            return AlertDialog(
              title: Text('Agregar Jugador'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                    ),
                    onChanged: (value){
                      nombre = value;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Arquero',
                    ),
                    onChanged: (value){
                      arquero = value;
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Agregar'),
                  onPressed: (){
                    Navigator.of(context).pop();
                    // Agregar jugador
                    FirestoreService().addJugador(nombre, arquero);
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