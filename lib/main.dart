import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:login/authentication/splash/splashScreen.dart';
import 'package:login/firebase_options.dart';
import 'package:login/authentication/signIn/user_login.dart';
import 'package:login/authentication/signUp/sign_up.dart';
// import 'package:login/organisation/org_profile/org_profile.dart';
import 'package:login/user/user_main.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => SplashScreen(), // Set the initial screen
        '/signin': (context) =>
            SignInScreen(), // Define the sign-in screen route
        '/signup': (context) => SignUpScreen(),
        '/user': (context) => ScreenHome(),
        '/login': (context) => SignInScreen() // Define the sign-up screen route
      },
    );
  }
}
