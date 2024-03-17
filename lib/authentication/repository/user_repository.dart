import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/user/user_main.dart';
//import 'package:waste_manage/functions/firebaseFunctions.dart';

class AuthServices {
  static signupUser(
      String email, String password, String name, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      print("Before updateDisplayName: ${userCredential.user!.displayName}");
      await userCredential.user!.updateDisplayName(name);
      print("After updateDisplayName: ${userCredential.user!.displayName}");

// save user data
      await FirebaseFirestore.instance
          .collection('UserDB')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'Address': '',
        'Landmark': '',
        'Pincode': '',
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Registration Successful'),
          backgroundColor: Colors.deepPurple));
    } on FirebaseAuthException catch (e) {
      // Handle exceptions
      print(e.toString());
    } catch (e) {
      // Handle other exceptions
    }
  }

  static signinUser(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Check if the user account still exists
      if (userCredential.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('You are Logged in'),
            backgroundColor: Colors.deepPurple));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => ScreenHome()), (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      // Handle exceptions (if needed)
      print(e.toString());

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid credentials'),
          backgroundColor: Colors.deepPurple));
    } catch (e) {
      // Handle other exceptions (if needed)
    }
  }
}

class OrgAuthServices {
  late FirebaseAuth _auth;
  late String _verificationId;

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          print('User signed up successfully with phone number: $phoneNumber');
          // Navigate to the next screen or perform any other action upon successful signup
        },
        verificationFailed: (FirebaseAuthException e) {
          print(
              'Failed to sign up user with phone number: $phoneNumber. Error: ${e.message}');
          // Handle the error as per your app's requirements
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          // Handle code sent (OTP) - You might want to navigate to OTP verification screen
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle timeout
        },
      );
    } catch (e) {
      print('Error signing up user with phone number: $phoneNumber. Error: $e');
      // Handle the error as per your app's requirements
    }
  }

  Future<void> signInWithPhoneNumber(String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
      print('User signed up successfully with OTP');
      // Navigate to the next screen or perform any other action upon successful signup
    } catch (e) {
      print('Failed to sign up user with OTP. Error: $e');
      // Handle the error as per your app's requirements
    }
  }
}

//   static Future<UserCredential?> signinAdmin(
//       String email, String password, BuildContext context) async {
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);

//       // Check if the user account still exists
//       if (userCredential.user != null) {
//         // You can perform additional checks here if needed
//         ScaffoldMessenger.of(context)
//             .showSnackBar(const SnackBar(content: Text('Admin logged in')));
//         return userCredential;
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Invalid admin credentials')));
//         return null;
//       }
//     } on FirebaseAuthException catch (e) {
//       // Handle exceptions
//       print("Error signing in as admin: $e");
//       return null;
//     }
//   }

//   static Future<void> signoutAdmin(BuildContext context) async {
//     try {
//       await FirebaseAuth.instance.signOut();
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text('Admin logged out')));
//       // Redirect to login page or desired destination
//     } catch (e) {
//       // Handle exceptions
//       print("Error signing out admin: $e");
//     }
//   }
// }



// class UserRepository extends GetxController {
//   static UserRepository get instance => Get.find();

//   final _db = FirebaseFirestore.instance;

//   createUser(UserModel user) async {
//     await _db
//         .collection("Users")
//         .add(user.toJson())
//         .whenComplete(() => Get.snackbar(
//             "Success", "Your account has been created.",
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.green.withOpacity(0.1),
//             colorText: Colors.green))
//         .catchError((error, stackTrace) {
//       () {
//         Get.snackbar("Error", "Something went Wrong. Try again",
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.redAccent.withOpacity(0.1),
//             colorText: Colors.red);
//         print(error.toString());
//       };
//     });
//   }
// }
