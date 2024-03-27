import 'package:flutter/material.dart';
import 'package:login/authentication/repository/user_repository.dart';
import 'package:login/authentication/splash/splashScreen.dart';
import 'package:login/resueable/reuseable_widget.dart';
//import 'package:login/user/user_main.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void signIn(formKey) async {
    if (await formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await AuthServices.signinUser(
          _emailController.text, _passwordController.text, context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  // try {
  //   String email = emailController.text;
  //   String password = passwordController.text;

  //   // Store the context in a local variable
  //   BuildContext localContext = context;

  // Sign in with email and password
  // await _auth.signInWithEmailAndPassword(
  //   email: email,
  //   password: password,
  // );

  // If successful, navigate to HomeScreen using the local context
  //   Navigator.push(
  //       localContext, MaterialPageRoute(builder: (_) => ScreenHome()));
  // } catch (e) {
  //   // Handle sign-in errors
  //   print('Error signing in: $e');
  // }

  Widget handleForgotPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => SplashScreen())),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actionsIconTheme: IconThemeData(color: Colors.white),
          iconTheme: IconThemeData(
            color: Colors.white, // Change this color to the desired color
          ),
          title: const Text(
            'SIGN IN',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Color.fromARGB(255, 21, 24, 29),
        ),
        body: Container(
            color: Color.fromARGB(255, 21, 24, 29),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                    child: Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        const SizedBox(
                          height: 30,
                        ),
                        reusableTextField("Enter Email", Icons.person_outline,
                            false, _emailController),
                        const SizedBox(
                          height: 20,
                        ),
                        ReusablePasswordField(
                          labelText: 'Enter Password',
                          prefixIcon: Icons.lock_outline,
                          isPasswordType: true,
                          controller: _passwordController,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        handleForgotPassword(context),
                        firebaseUIButton(context, "Sign In", _isLoading,
                            () => signIn(_formKey)),
                        navigateToSignUp("Sign Up", true, context),

                        // forgetPassword(context),
                      ]),
                    )))),
      ),
    );
  }

//   TextFormField reusablePasswordField(
//     String text,
//     IconData? icon,
//     bool isPasswordType,
//     TextEditingController controller,
//   ) {
//     bool _obscure=isPasswordType;
//     return TextFormField(
//       controller: controller,
//       obscureText: _obscure,
//       enableSuggestions: !isPasswordType,
//       autocorrect: !isPasswordType,
//       cursorColor: Colors.white,
//       style: TextStyle(color: Colors.white.withOpacity(0.9)),
//       decoration: InputDecoration(
//         prefixIcon: Icon(
//           icon,
//           color: Colors.white70,
//         ),
//         suffixIcon: IconButton(
//           icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off,color: Colors.white,),
//           onPressed: () {
//             setState(() {
//               _obscure = !_obscure;
//             });
//           },
//         ), // Icon
//         labelText: text,
//         labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
//         filled: true,
//         floatingLabelBehavior: FloatingLabelBehavior.never,
//         fillColor: Colors.white.withOpacity(0.3),
//         border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30.0),
//             borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
//       ), // InputDecoration
//       keyboardType: isPasswordType
//           ? TextInputType.visiblePassword
//           : TextInputType.emailAddress,
//       validator: isPasswordType
//           ? (value) {
//               if (value!.length < 6) {
//                 return 'Please Enter a Password of at least 6 characters';
//               } else {
//                 return null;
//               }
//             }
//           : (value) {
//               if (value!.isEmpty) {
//                 return 'Please fill the field';
//               } else {
//                 return null;
//               }
//             },

// // TextField

// // OutlineInputBorder
//     );
//   }
}

class ReusablePasswordField extends StatefulWidget {
  final String labelText;
  final IconData? prefixIcon;
  final bool isPasswordType;
  final TextEditingController controller;

  ReusablePasswordField({
    required this.labelText,
    required this.prefixIcon,
    required this.isPasswordType,
    required this.controller,
  });

  @override
  _ReusablePasswordFieldState createState() => _ReusablePasswordFieldState();
}

class _ReusablePasswordFieldState extends State<ReusablePasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      enableSuggestions: !widget.isPasswordType,
      autocorrect: !widget.isPasswordType,
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white.withOpacity(0.9)),
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.prefixIcon,
          color: Colors.white70,
        ),
        suffixIcon: IconButton(
          icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
          color: Colors.white,
          onPressed: () {
            setState(() {
              _obscure = !_obscure;
            });
          },
        ),
        labelText: widget.labelText,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
      ),
      keyboardType: widget.isPasswordType
          ? TextInputType.visiblePassword
          : TextInputType.emailAddress,
      validator: widget.isPasswordType
          ? (value) {
              if (value!.length < 6) {
                return 'Please enter a password of at least 6 characters';
              }
              return null;
            }
          : (value) {
              if (value!.isEmpty) {
                return 'Please fill the field';
              }
              return null;
            },
    );
  }
}
