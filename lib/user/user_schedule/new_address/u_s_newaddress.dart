import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/resueable/reuseable_widget.dart';

class NewAddressForm extends StatefulWidget {
  const NewAddressForm({super.key}); // Corrected constructor syntax

  @override
  State<NewAddressForm> createState() => _NewAddressFormState();
}

class _NewAddressFormState extends State<NewAddressForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
    });
  }

  Future<void> _submitAddress() async {
    try {
      final data = {
        'Address': addressController.text,
        'Pincode': pinCodeController.text,
        'Landmark': landmarkController.text,
      };

      await FirebaseFirestore.instance
          .collection('UserAddress')
          .doc(_user!.uid)
          .collection('Addresses')
          .doc('address')
          .set({
        'a': FieldValue.arrayUnion([data])
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address submitted successfully')),
      );

      // Clear the input fields
      addressController.clear();
      pinCodeController.clear();
      landmarkController.clear();
      Navigator.of(context).pop();
    } catch (error) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting address: $error')),
      );
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController addressController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Enter necessary fields to add a new Address"),
              const SizedBox(height: 16.0),
              reusableAddressField("Address", true, false, addressController),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: pinCodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Pincode",
                  labelStyle:
                      TextStyle(color: Colors.deepPurple.withOpacity(0.9)),
                  filled: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                  ),
                ),
                validator: (value) {
                  if (value!.length != 6) {
                    return "Enter a valid Pincode of 6 digits";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              reusableAddressField(
                  "Landmark", false, false, landmarkController),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _submitAddress();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
