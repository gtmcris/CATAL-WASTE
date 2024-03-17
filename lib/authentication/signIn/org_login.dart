import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/authentication/signIn/org_otp.dart';

class OrgLoginScreen extends StatefulWidget {
  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<OrgLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId = '';

  Future<void> _verifyPhoneNumber(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          // Navigate to the next screen or perform any other action upon successful login
          print('User logged in successfully with phone number: $phoneNumber');
        },
        verificationFailed: (FirebaseAuthException e) {
          print(
              'Failed to log in user with phone number: $phoneNumber. Error: ${e.message}');
          // Handle the error as per your app's requirements
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            this.verificationId = verificationId;
          });
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OtpScreen(verificationId: verificationId),
          ));
          // Handle code sent (OTP) - You might want to navigate to OTP verification screen
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout
        },
      );
    } catch (e) {
      print('Failed to log in user with phone number: $phoneNumber. Error: $e');
      // Handle the error as per your app's requirements
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 21, 24, 29),
        appBar: AppBar(
          title: Text('Phone Number Login'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Enter the Phone number",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  reusablePhoneField('Phone Number', _phoneNumberController),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _verifyPhoneNumber(_phoneNumberController.text);
                      }
                    },
                    child: Text('VERIFY'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

TextFormField reusablePhoneField(
    String text, TextEditingController controller) {
  return TextFormField(
    controller: controller,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.phone,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(width: 0, style: BorderStyle.none),
      ),
    ),
    keyboardType: TextInputType.phone,
    validator: (value) {
      if (value!.length < 10) {
        return 'Please Enter a valid number';
      } else {
        return null;
      }
    },
  );
}
