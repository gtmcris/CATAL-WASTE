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
  late TextEditingController _userNameController;
  late TextEditingController _numberController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _numberController = TextEditingController();
    _emailController = TextEditingController();
    _loadOrgDetails(); // Load organization details from shared preferences
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _numberController.dispose();
    _emailController.dispose();
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
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'User Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 35, 33, 43), // Background color
      ),
      backgroundColor: Color.fromARGB(255, 35, 33, 43), // Background color
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _userNameController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(
                      r'^[a-zA-Z\s]*$')), // Allow only letters and whitespaces
                ],
                style: TextStyle(color: Colors.white), // Text color
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white), // Font color
                ),
              ),

              SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10), // Limit to 10 digits
                ],
                controller: _numberController,
                style: TextStyle(color: Colors.white), // Text color
                decoration: InputDecoration(
                  labelText: 'Contact Number',
                  labelStyle: TextStyle(color: Colors.white), // Font color
                ),
              ),

              SizedBox(height: 20),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
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
                style: TextStyle(color: Colors.white), // Text color
                decoration: InputDecoration(
                  labelText: 'E-mail Address',
                  labelStyle: TextStyle(color: Colors.white), // Font color
                  errorText:
                      _contactDetailsError, // Display error message if email is invalid
                  errorStyle:
                      TextStyle(color: Colors.white), // Error font color
                ),
              ),
              SizedBox(height: 20), // Add space between TextField and Button
              ElevatedButton(
                onPressed: () => _saveOrgDetails(context),
                child: Text(
                  'Save',
                  style: TextStyle(
                      color:
                          Color.fromARGB(255, 10, 3, 47)), // Button font color
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(
                          255, 252, 255, 228)), // Button background color
                ),
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
      _userNameController.text = prefs.getString('userName') ?? '';
      _numberController.text = prefs.getString('phoneNumber') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
    });
  }

  Future<void> _saveOrgDetails(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', _userNameController.text);
    prefs.setString('phoneNumber', _numberController.text);
    prefs.setString('email', _emailController.text);
    widget.setProfileItem({
      'Name': _userNameController.text,
      'Number': _numberController.text,
      'Email': _emailController.text,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User details saved')),
    );

    Navigator.pop(context, {
      'name': _userNameController.text,
      'number': _numberController.text,
      'email': _emailController.text,
    });
  }
}
