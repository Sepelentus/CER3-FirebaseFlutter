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
          
                      return ListTile(
                        leading: Icon(MdiIcons.account),
                        title: Text('${copa['nombre_titulo']} \nFecha: ' + fechaFormateada),
                        subtitle: Text('${copa['ultimo_partido']}'),
                      );
                    },
                    
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}