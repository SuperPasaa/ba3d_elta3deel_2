import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_second/helper/ShowSnackBar.dart';
import 'package:project_second/pages/Sign_Up_Page.dart';
import 'package:project_second/widgets/CustomMaterilButton.dart';
import 'package:project_second/widgets/CustomTextField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool isPasswordHidden = true;
  GlobalKey<FormState> formKey = GlobalKey();
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushNamedAndRemoveUntil("HomePage", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('Assets/Background_Login.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 125,
                  ),
                  const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Welcome Back..',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextForm(
                    hinttext: 'Enter email',
                    mycontroller: email,
                    icon: Icons.email,
                    obsecureTe: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomTextForm(
                    hinttext: 'Enter password',
                    mycontroller: password,
                    icon: Icons.lock,
                    obsecureTe: isPasswordHidden,
                    iconButton: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordHidden = !isPasswordHidden;
                        });
                      },
                      icon: !isPasswordHidden ? const Icon(Icons.visibility , color: Colors.black,) :  const Icon( Icons.visibility_off , color: Colors.grey,),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                      await  FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email.text);
                        ShowSnackBar(
                            context, 'Password reset is sent to your password');
                      } on FirebaseAuthException {
                        ShowSnackBar(context,
                              'Please enter an email or check that email entered is valid then try again!');
                      }
                    },
                    child: const Text(
                      'Forget Password ?',
                      textAlign: TextAlign.end,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: CustomButton(
                      text: 'Sign In',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            );
                            if (credential.user!.emailVerified) {
                              LoginNav(context);
                            } else {
                              ShowSnackBar(context, 'Please verify your email');
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found' ||
                                e.code == 'wrong-password') {
                              ShowSnackBar(
                                  context, 'invalid email or password');
                            } else {
                              // ignore: use_build_context_synchronously
                              ShowSnackBar(
                                  context, 'An error occurred : ${e.code}');
                            }
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    textAlign: TextAlign.center,
                    'OR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: MaterialButton(
                      color: Colors.blue,
                      onPressed: () {
                        signInWithGoogle();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'Assets/google.jpg',
                            height: 22,
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Sign in With Google',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have an account ?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          ' Register now',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[300]),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SignUpPage();
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void LoginNav(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil("HomePage", (route) => false);
  }
}
