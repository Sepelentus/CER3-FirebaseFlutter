import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_certamen/services/firestore_services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';


class Copas extends StatelessWidget {
  const Copas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 0, 2, 3),
          title: Text(
              style: TextStyle(color: Colors.white), 'COPAS GANADAS'),
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
                      var copa = snapshot.data!.docs[index];
                          DateTime fechacopa = (copa['fecha'] as Timestamp).toDate();
                          var fechaFormateada = DateFormat('dd/MM/yyyy').format(fechacopa);
          
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
                          leading: Icon(MdiIcons.trophy, color: Colors.amber, size: 40,),
                          title: Text('${copa['nombre_titulo']} \nFecha: ' + fechaFormateada , style: TextStyle(fontSize: 15 ,color: Colors.white, fontWeight: FontWeight.bold),),
                          subtitle: Text('${copa['ultimo_partido']}', style: TextStyle(fontSize:15, color: Colors.white, fontWeight: FontWeight.bold),),
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
      floatingActionButton: FloatingActionButton(onPressed: (){
        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('Añadir Copa'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: 'Nombre de la Copa'),
                    controller: TextEditingController(),
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: 'Ultimo Partido'),
                    controller: TextEditingController(),
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: 'Fecha de la Copa'),
                    controller: TextEditingController(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: (){
                    FirestoreService().addCopa('nombre_titulo', 'ultimo_partido', 'fecha');
                    Navigator.pop(context);
                  },
                  child: Text('Añadir'),
                ),
              ],
            );
          },
        );
      },
      )
    );
  }
}