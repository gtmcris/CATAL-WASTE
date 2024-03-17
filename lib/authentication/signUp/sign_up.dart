import 'package:flutter/material.dart';
import 'package:login/authentication/repository/user_repository.dart';
import 'package:login/authentication/signIn/user_login.dart';
import 'package:login/resueable/reuseable_widget.dart';
//import 'package:login/user/user_main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void signUp(formKey) async {
    if (await formKey.currentState!.validate()) {
      await AuthServices.signupUser(
        _emailTextController.text,
        _passwordTextController.text,
        _userNameTextController.text,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 21, 24, 29),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(
            color: Colors.white, // Change this color to the desired color
          ),
          backgroundColor: Color.fromARGB(255, 21, 24, 29),
          elevation: 0,
          title: const Text(
            "Sign Up",
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 217, 231, 255)),
          ),
        ),
        body: Container(
            color: Color.fromARGB(255, 21, 24, 29),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter UserName", Icons.person_outline,
                        false, _userNameTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Email Id", Icons.person_outline,
                        false, _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    ReusablePasswordField(
                      labelText: 'Enter Password',
                      prefixIcon: Icons.lock_outline,
                      isPasswordType: true,
                      controller: _passwordTextController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    firebaseUIButton(
                        context,
                        "Sign Up",
                        () => {
                              // FirebaseAuth.instance
                              //     .createUserWithEmailAndPassword(
                              //         email: _emailTextController.text,
                              //         password: _passwordTextController.text)
                              //     .then((value) {
                              //   Navigator.of(context).pushReplacement(
                              //       MaterialPageRoute(
                              //           builder: (ctx2) => SignInScreen()));
                              // }).onError((error, stackTrace) {
                              //   print("Error ${error.toString()}");
                              // }),
                              signUp(_formKey),
                            }),
                    navigateToSignUp("Sign In", false, context)
                  ],
                ),
              ),
            ))),
      ),
    );
  }
}
