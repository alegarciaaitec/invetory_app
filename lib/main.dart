import 'package:flutter/material.dart';
import 'package:invetory_app/providers/user_provider.dart';
import 'package:invetory_app/screens/user_list_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestión de Usuarios',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[100],
          appBarTheme: const AppBarTheme(elevation: 2, centerTitle: true),
        ),
        home: const UserListScreen(),
      ),
    );
  }
}
