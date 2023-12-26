import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_second/Pages/home_page.dart';
import 'package:project_second/Pages/Login_Page.dart';
import 'package:project_second/Pages/Welcome.dart';
import 'package:project_second/firebase_options.dart';
import 'package:project_second/pages/Sign_Up_Page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Test()); 
}

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified
          ? HomePage()
          : WelcomePage(),
      routes: {
        "HomePage": (context) => HomePage(),
        "LoginPage": (context) => LoginPage(),
        "SignUpPage": (context) => SignUpPage(),
      },
    );
  }
}
