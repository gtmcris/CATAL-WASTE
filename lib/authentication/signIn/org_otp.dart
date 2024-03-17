import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:libphonenumber/libphonenumber.dart';
import 'package:login/organisation/main_org.dart';

class OtpScreen extends StatefulWidget {
  String verificationId;
  OtpScreen({super.key, required this.verificationId});

  @override
  _PhoneSignUpScreenState createState() => _PhoneSignUpScreenState();
}

class _PhoneSignUpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _smsCodeController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithPhoneNumber(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId, smsCode: smsCode);
      await _auth.signInWithCredential(credential).then((value) =>
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => OrgMain())));
      // Navigate to the next screen or perform any other action upon successful signup
      print('User signed up successfully with OTP');
    } catch (e) {
      print('Failed to sign up user with OTP. Error: $e');
      // Handle the error as per your app's requirements
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 21, 24, 29),
        appBar: AppBar(
          title: Text(
            'Phone Number Signup',
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Enter the OTP',
                      style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _smsCodeController,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.white.withOpacity(0.9)),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.message,
                          color: Colors.white70,
                        ),
                        labelText: "OTP",
                        labelStyle:
                            TextStyle(color: Colors.white.withOpacity(0.9)),
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        fillColor: Colors.white.withOpacity(0.3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty || value.length != 6) {
                          return 'Please enter OTP';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _signInWithPhoneNumber(_smsCodeController.text);
                        }
                      },
                      child: Text('Verify OTP'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
