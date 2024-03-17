import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrgDetails extends StatefulWidget {
  final Function(Map<String, dynamic>) setProfileItem;
  Map<String, dynamic> profileItem;
  OrgDetails({required this.setProfileItem, required this.profileItem});
  @override
  _OrgDetailsState createState() => _OrgDetailsState();
}

class _OrgDetailsState extends State<OrgDetails> {
  late TextEditingController _organizationNameController;
  late TextEditingController _wasteCategoriesController;
  late TextEditingController _contactDetailsController;

  @override
  void initState() {
    super.initState();
    _organizationNameController = TextEditingController();
    _wasteCategoriesController = TextEditingController();
    _contactDetailsController = TextEditingController();
    _loadOrgDetails(); // Load organization details from shared preferences
  }

  @override
  void dispose() {
    _organizationNameController.dispose();
    _wasteCategoriesController.dispose();
    _contactDetailsController.dispose();
    super.dispose();
  }

  String? _contactDetailsError;
  bool _isValidEmail(String email) {
    // Email regex pattern
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _organizationNameController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(
                      r'^[a-zA-Z\s]*$')), // Allow only letters and whitespaces
                ],
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),

              SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                ],
                controller: _wasteCategoriesController,
                decoration: InputDecoration(
                  labelText: 'Contact Number',
                ),
              ),

              SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _contactDetailsController,
                onChanged: (value) {
                  setState(() {
                    if (_isValidEmail(value)) {
                      _contactDetailsError = null; // No error if email is valid
                    } else {
                      _contactDetailsError =
                          'Enter a valid email'; // Error message if email is invalid
                    }
                  });
                },
                decoration: InputDecoration(
                  labelText: 'E-mail Address',
                  errorText:
                      _contactDetailsError, // Display error message if email is invalid
                ),
              ),
              SizedBox(height: 20), // Add space between TextField and Button
              ElevatedButton(
                onPressed: () => _saveOrgDetails(context),
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
    });
  }

  Future<void> _saveOrgDetails(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('organizationName', _organizationNameController.text);
    prefs.setString('wasteCategories', _wasteCategoriesController.text);
    prefs.setString('contactDetails', _contactDetailsController.text);
    widget.setProfileItem({
      'Name': _organizationNameController.text,
      'Waste': _wasteCategoriesController.text,
      'contactDetails': _contactDetailsController.text,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User details saved')),
    );

    Navigator.pop(context, {
      'name': _organizationNameController.text,
      'number': _wasteCategoriesController.text,
      'email': _contactDetailsController.text,
    });
  }
}
