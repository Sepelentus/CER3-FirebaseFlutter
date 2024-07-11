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
      backgroundColor: Color.fromARGB(255, 3, 1, 30),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                child: Image.asset(
                  'assets/images/cc.png',
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                '¡Bienvenido!',
                style: TextStyle(
                  color: Color.fromARGB(255, 240, 6, 6),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              Text(
                'Porfavor, inicie sesion con Google',
                style: TextStyle(
                  color: Color.fromARGB(255, 227, 227, 227),
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 5, 33, 126),
                  foregroundColor: Color(0xFF1b141a),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(color: Colors.white)
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
                        content: Text('Inicio de sesión con Google fallido'),
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
                    color: Color(0xFFdedbde),
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}