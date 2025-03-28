import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home_screen.dart'; // Ajusta la ruta según tu estructura de proyecto

class FacebookLoginScreen extends StatelessWidget {
  const FacebookLoginScreen({super.key});

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken.tokenString);

        final UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);

        // Usuario autenticado correctamente
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, ${authResult.user?.displayName ?? 'User'}!')),
        );

        // Navega a la pantalla principal
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        // Inicio de sesión cancelado por el usuario
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Facebook login canceled by user')),
        );
      }
    } catch (error) {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error in Facebook Login: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login with Facebook'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => signInWithFacebook(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text(
            'Login with Facebook',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}