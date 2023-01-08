// ignore: unused_import
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hpapp/authentication_service.dart';
import 'package:hpapp/signinscreen.dart';
import 'package:hpapp/signupscreen.dart';
import 'package:provider/provider.dart';
import 'applyingscreen.dart';
import 'addingscreen.dart';
import 'accountscreen.dart';
import 'homescreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'HB app',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<AuthenticationService>(
            create: (_) => AuthenticationService(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
            initialData: null,
          )
        ],
        child: MaterialApp(
          title: 'HB app',
          theme: ThemeData(
            primaryColor: Color.fromARGB(255, 25, 25, 25),
            accentColor: Colors.white,
          ),
          initialRoute: '/first',
          routes: {
            '/': (context) => CreateHomePage(),
            '/first': (context) => AuthenticationWrapper(),
            '/applyingscreen': (context) => CreateApplyingScreen(),
            '/addingscreen': (context) => CreateAddingScreen(),
            '/accountscreen': (context) => CreateAccountScreen(),
            '/signupscreen': (context) => CreateSignUpScreen(),
            '/signinscreen': (context) => CreateSignInScreen(),
          },
        ));
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return CreateHomePage();
    } else {
      return CreateSignInScreen();
    }
  }
}
