import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'todo_provider.dart'; // import provider kita
// import halaman utama (yang akan kita buat selanjutnya)

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Bungkus MaterialApp dengan ChangeNotifierProvider
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(), // Membuat instance dari provider kita
      child: MaterialApp(
        title: 'To-Do Mini',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(), // Halaman utama aplikasi kita
      ),
    );
  }
} 