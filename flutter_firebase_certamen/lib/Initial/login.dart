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
      backgroundColor: Color(0xFF1b141a),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Iniciar Sesión',
                style: TextStyle(
                  color: Color(0xFF3199c9),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              TextField(
                style: TextStyle(color: Color(0xFF3199c9)),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFdedbde),
                  hintText: 'Correo Electrónico',
                  hintStyle: TextStyle(color: Color(0xFF3199c9)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: TextStyle(color: Color(0xFF3199c9)),
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFdedbde),
                  hintText: 'Contraseña',
                  hintStyle: TextStyle(color: Color(0xFF3199c9)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF3199c9),
                  foregroundColor: Color(0xFF1b141a),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
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
                  'assets/img/google_icon.png',
                  height: 24.0,
                  width: 24.0,
                ),
                label: Text(
                  'Ingresar con Google',
                  style: TextStyle(
                    color: Color(0xFFdedbde),
                    fontSize: 16,
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