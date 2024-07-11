import 'package:flutter/material.dart';
import 'package:flutter_firebase_certamen/pages/copas.dart';
import 'package:flutter_firebase_certamen/pages/jugadores_page.dart';
import 'package:icons_plus/icons_plus.dart';

class Principalpage extends StatelessWidget {
  const Principalpage({super.key});

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Container(
            height: 65,
            child: Image.asset(
              'assets/images/colo-colo-32.png',
              fit: BoxFit.contain,
            ),
          ),
          
          
          
          
          
          //Text('COLO-COLO', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          bottom:TabBar(
            //255,23,184,255
            labelColor: Color.fromARGB(255, 255, 0, 0),
            unselectedLabelColor: Color.fromARGB(83, 255, 255, 255),
            indicatorColor: Color.fromARGB(255, 255, 255, 255),
            tabs: [Tab(icon: Icon(BoxIcons.bx_user)), Tab(icon: Icon(BoxIcons.bx_trophy))],
          ),
        ),
        body: TabBarView(
          children: [JugadoresPage(), Copas()],
        ),
      ),
    );
  }
}
