// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kpi_s_fct/main.dart';
import 'package:kpi_s_fct/screens/login_screen.dart';
import 'package:kpi_s_fct/firebase_options.dart'; // Asegúrate de que este archivo exista

void main() {
  setUpAll(() async {
    // Inicializa Firebase antes de ejecutar las pruebas
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform, // Usa las opciones generadas por flutterfire
    );
  });

  testWidgets('Carga de la pantalla principal', (WidgetTester tester) async {
    // Construye la aplicación y espera a que se renderice
    await tester.pumpWidget(const MainApp());
    // Verifica que la pantalla principal se cargue correctamente
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget); // Verifica que LoginScreen esté presente
  });
}
