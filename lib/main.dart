import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../screens/splash_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/auth_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //initialize Firebase
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'Chat App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: snapshot.connectionState != ConnectionState.done
              ? SplashScreen()
              : AuthScreen(),
        );
      },
    );
  }
}
