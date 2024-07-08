import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_certamen/services/firestore_services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Copas extends StatelessWidget {
  const Copas({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Copas ganadas'),
      ),
      body: Padding(
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
                  return ListTile(
                    leading: Icon(MdiIcons.account),
                    title: Text('${copa['nombre_titulo']}, el dia ${copa['fecha']}'),
                    subtitle: Text('${copa['ultimo_partido']}'),
                  );
                },
                
                );
            }
          },
        ),
      ),
    );
  }
}