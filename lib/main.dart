import 'package:cine_list/screens/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cine Explorer',
      theme: ThemeData(
        // Define o Roxo como cor principal
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),

      home: const HomePage(),
    );
  }
}
