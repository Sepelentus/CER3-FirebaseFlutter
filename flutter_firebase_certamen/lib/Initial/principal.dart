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
          title: SizedBox(
            
            child: Image.asset(
              'assets/images/colo_colo.png',
              fit: BoxFit.fill,
            ),
          ),
          bottom: const TabBar(
            //255,23,184,255
            labelColor: Color.fromARGB(255, 57, 16, 223),
            unselectedLabelColor: Colors.black,
            indicatorColor: Color.fromARGB(255,23,184,255),
            tabs: [Tab(icon: Icon(BoxIcons.bx_user)), Tab(icon: Icon(BoxIcons.bx_trophy))],
          ),
        ),
        body: const TabBarView(
          children: [JugadoresPage(), Copas()],
        ),
      ),
    );
  }
}
