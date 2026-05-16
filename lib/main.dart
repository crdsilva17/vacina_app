import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vacina_app/screens/check_screen.dart';
import 'package:vacina_app/util/my_custom_scroll_behavior.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Imune',
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('pt', 'BR'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: Colors.blue[800], // Azul principal
        ),
        // Configura o estilo padrão de todos os inputs do app
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white, // Campos brancos
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.blue,
            ), // Remove a borda preta padrão
          ),
          labelStyle: const TextStyle(
            color: Colors.black,
            backgroundColor: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[900],
            // Fundo do botão
            foregroundColor: Colors.white,
            // Cor do texto/ícone do botão
            textStyle: TextStyle(fontSize: 18),
            minimumSize: const Size(double.infinity, 50),
            // Botão largo
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      scrollBehavior: MyCustomScrollBehavior(),
      home: const CheckScreen(),
    );
  }
}
