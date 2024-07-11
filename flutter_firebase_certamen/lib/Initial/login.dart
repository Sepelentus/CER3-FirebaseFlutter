import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_certamen/Initial/principal.dart';
import 'package:flutter_firebase_certamen/services/autentificacion_google.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({Key? key});

  @override
  Widget build(BuildContext context) {
    final AutenticacionGoogle _authService = AutenticacionGoogle();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/estadio.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/cc.png',
                    fit: BoxFit.contain,
                    height: 190.0,
                    width: 200.0,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '¡Bienvenido!',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //SizedBox(height: 80),
                  Text(
                    'Porfavor, inicie sesion con Google',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      foregroundColor: Color(0xFF1b141a),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        
                        borderRadius: BorderRadius.circular(30),
                        
                      ),
                    ),
                    onPressed: () async {
                      User? user = await _authService.autentificaciongoogle();
                      if (user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Principalpage(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Inicio de sesión con Google fallido', style: TextStyle( fontWeight: FontWeight.bold),),
                          ),
                        );
                      }
                    },
                    icon: Image.asset(
                      'assets/images/google_icon.png',
                      height: 32.0,
                      width: 32.0,
                    ),
                    label: Text(
                      'Ingresar con Google',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}