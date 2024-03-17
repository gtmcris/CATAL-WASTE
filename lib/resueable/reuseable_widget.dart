import "package:flutter/material.dart";
import 'package:login/authentication/signIn/user_login.dart';
import "package:login/authentication/signUp/sign_up.dart";
//import "package:helo/user/user_main.dart";
//import "package:helo/login/signUp.dart";
//import "package:helo/user/user_main.dart";

TextFormField reusableTextField(
  String text,
  IconData? icon,
  bool isPasswordType,
  TextEditingController controller,
) {
  return TextFormField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ), // Icon
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ), // InputDecoration
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
    validator: isPasswordType
        ? (value) {
            if (value!.length < 6) {
              return 'Please Enter a Password of at least 6 characters';
            } else {
              return null;
            }
          }
        : (value) {
            if (value!.isEmpty) {
              return 'Please fill the field';
            } else {
              return null;
            }
          },

// TextField

// OutlineInputBorder
  );
}

Row reusablePhoneField(
  String text,
  TextEditingController controller,
) {
  return Row(
    children: [
      TextFormField(
          controller: controller,
          cursorColor: Colors.white,
          style: TextStyle(color: Colors.white.withOpacity(0.9)),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.phone,
              color: Colors.white70,
            ), // Icon
            labelText: text,
            labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: Colors.white.withOpacity(0.3),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide:
                    const BorderSide(width: 0, style: BorderStyle.none)),
          ), // InputDecoration
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value!.length < 10) {
              return 'Please Enter a valid number';
            } else {
              return null;
            }
          }

          // TextField

          // OutlineInputBorder
          ),
    ],
  );
}

TextFormField reusableAddressField(String text, bool isMul, bool isEmail,
    TextEditingController controller, // Pass controller for the text field
    {bool isPhone = false}) {
  return TextFormField(
    controller: controller, // Set the controller for the text field
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.deepPurple.withOpacity(0.9)),
    decoration: InputDecoration(
      labelText: text,
      labelStyle: TextStyle(color: Colors.deepPurple.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    keyboardType: isPhone
        ? TextInputType.phone
        : isMul
            ? TextInputType.multiline
            : TextInputType.name,
    maxLines: isMul ? 4 : null,
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a value';
      }
      if (isEmail && !(value.contains('@') && value.contains('.'))) {
        return 'Please enter a valid email';
      }
      if (isPhone && value.length != 10) {
        return 'Please enter a valid phone number';
      }
      return null;
    },
  );
}

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTa) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTa();
      },
      // Text
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        isLogin ? 'LOG IN' : 'SIGN UP',
        style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16), // TextStyle
      ),
    ), // ElevatedButton
  ); // Container
}

Container firebaseUIButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () async {
        await onTap();
      },
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

Row navigateToSignUp(String val, bool isSignUp, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(isSignUp ? "Don't have an account? " : "Already have an Account ",
          style: const TextStyle(color: Colors.white70)),
      GestureDetector(
        onTap: isSignUp
            ? () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignUpScreen()));
              }
            : () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
              },
        child: Text(
          val,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}

// Widget travel() {
//   return MaterialButton(
//       onPressed: () {
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => MyHomePage()));
//       },
//       color: Colors.blue,
//       textColor: Colors.white,
//       child: Text("Login"));
// }
