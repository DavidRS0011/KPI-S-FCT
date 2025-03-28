import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../widgets/animated_logo.dart';
import 'package:kpi_s_fct/screens/home_screen.dart'; // Ajusta la ruta según tu estructura de proyecto
import 'services/auth_service.dart'; // Importa el servicio de autenticación
import 'dart:js' as js;

// Configuración de GoogleSignIn para dispositivos móviles
final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: ['email'], // Solicita acceso al correo electrónico del usuario
);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _controller;
  final AuthServices _authServices = AuthServices(); // Instancia del servicio de autenticación

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // Animación de ida y vuelta
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    if (_controller.isAnimating) {
      _controller.stop();
    }
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loginWithEmail() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _usernameController.text,
          password: _passwordController.text,
        );
        Navigator.pop(context); // Cierra el indicador de carga
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, ${userCredential.user?.displayName ?? 'User'}!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context); // Cierra el indicador de carga
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred')),
        );
      }
    }
  }

  Future<void> _loginWithGoogle() async {
    try {
      final userCredential = await _authServices.signInWithGoogle(); // Llama al método del servicio
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Welcome, ${userCredential.user?.displayName ?? 'User'}!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'An error occurred during Google sign-in')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }

  Future<void> _loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success && result.accessToken != null) {
        final String accessToken = result.accessToken!.tokenString;
        final credential = FacebookAuthProvider.credential(accessToken);
        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, ${userCredential.user?.displayName ?? 'User'}!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.message ?? 'Facebook login failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _loginWithFacebookWeb() async {
    try {
      // Verifica si el objeto FB y el método FB.login están disponibles
      if (js.context.hasProperty('FB') && js.context['FB'].hasProperty('login')) {
        js.context.callMethod('FB.login', [
          (response) {
            if (response['status'] == 'connected') {
              final accessToken = response['authResponse']['accessToken'];
              print('Facebook Access Token: $accessToken');
              // Aquí puedes usar el accessToken para autenticarte con Firebase
            } else {
              print('Facebook login failed: ${response['status']}');
            }
          },
          {'scope': 'email,public_profile'}
        ]);
      } else {
        print('Facebook SDK not loaded or FB.login is undefined');
      }
    } catch (e) {
      print('Error during Facebook login: $e');
    }
  }

  void _resetPassword() {
    final email = _usernameController.text;
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password reset email sent')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange, Colors.deepOrange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo animado
              AnimatedLogo(controller: _controller),
              const SizedBox(height: 32.0),

              // Campo de texto para el nombre de usuario
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Campo de texto para la contraseña
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
                      .hasMatch(value)) {
                    return 'Password must contain at least 8 characters, including uppercase, lowercase, number, and special character';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),

              // Botón para restablecer la contraseña
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _resetPassword,
                  child: const Text('Forgot Password?'),
                ),
              ),
              const SizedBox(height: 16.0),

              // Botón para iniciar sesión con correo electrónico
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loginWithEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 16.0),

              // Botón para iniciar sesión con Google
              SignInButton(
                Buttons.Google,
                onPressed: _loginWithGoogle,
              ),
              const SizedBox(height: 16.0),

              // Botón para iniciar sesión con Facebook (funciona tanto en web como en móviles)
              SignInButton(
                Buttons.Facebook,
                onPressed: () async {
                  // Verifica si estás en la web o en un dispositivo móvil
                  if (js.context.hasProperty('FB')) {
                    // Lógica para la web
                    await _loginWithFacebookWeb();
                  } else {
                    // Lógica para dispositivos móviles
                    await _loginWithFacebook();
                  }
                },
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}