import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrgDetails extends StatefulWidget {
  @override
  _OrgDetailsState createState() => _OrgDetailsState();
}

class _OrgDetailsState extends State<OrgDetails> {
  late TextEditingController _organizationNameController;
  late TextEditingController _wasteCategoriesController;
  late TextEditingController _contactDetailsController;
  late TextEditingController _pincodeController; // New controller for pincode
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  void initState() {
    super.initState();
    _organizationNameController = TextEditingController();
    _wasteCategoriesController = TextEditingController();
    _contactDetailsController = TextEditingController();
    _pincodeController = TextEditingController(); // Initialize the pincode controller
    _loadOrgDetails(); // Load organization details from shared preferences
  }

  @override
  void dispose() {
    _organizationNameController.dispose();
    _wasteCategoriesController.dispose();
    _contactDetailsController.dispose();
    _pincodeController.dispose(); // Dispose the pincode controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organization Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _organizationNameController,
                decoration: InputDecoration(
                  labelText: 'Organization Name',
                  hintText: 'Enter organization name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter organization name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _wasteCategoriesController,
                decoration: InputDecoration(
                  labelText: 'Waste Categories',
                  hintText: 'Enter waste categories (comma separated)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _contactDetailsController,
                decoration: InputDecoration(
                  labelText: 'Contact Details',
                  hintText: 'Enter contact details (10-digit number)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact details';
                  } else if (value.length != 10 ||
                      int.tryParse(value) == null) {
                    return 'Contact details should be a 10-digit number';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20), // Add spacing
              TextFormField(
                controller: _pincodeController,
                decoration: InputDecoration(
                  labelText: 'Pincode',
                  hintText: 'Enter pincode',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pincode';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveOrgDetails(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadOrgDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _organizationNameController.text =
          prefs.getString('organizationName') ?? '';
      _wasteCategoriesController.text =
          prefs.getString('wasteCategories') ?? '';
      _contactDetailsController.text = prefs.getString('contactDetails') ?? '';
      _pincodeController.text = prefs.getString('pincode') ?? ''; // Load pincode
    });
  }

  Future<void> _saveOrgDetails(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final organizationName = _organizationNameController.text;
    final wasteCategoriesString = _wasteCategoriesController.text;
    final contactDetails = _contactDetailsController.text;
    final pincode = _pincodeController.text; // Get pincode

    // Split the waste categories string by commas
    final wasteCategoriesList =
        wasteCategoriesString.split(',').map((e) => e.trim()).toList();
    print(wasteCategoriesList);
    // Save to SharedPreferences
    prefs.setString('organizationName', organizationName);
    prefs.setString('wasteCategories', wasteCategoriesString);
    prefs.setString('contactDetails', contactDetails);
    prefs.setString('pincode', pincode); // Save pincode

    // Initialize Firebase
    await Firebase.initializeApp();
    // Get a reference to Firestore database
    final firestore = FirebaseFirestore.instance;

    try {
      // Add the organization data to Firestore
      await firestore.collection("organisation").doc().set({
        'organizationName': organizationName,
        'wasteCategories': wasteCategoriesList,
        'contactDetails': contactDetails,
        'pincode': pincode, // Add pincode to Firestore
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Organization details saved')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save organization details')),
      );
    }
  }
}
