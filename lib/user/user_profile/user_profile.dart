import 'dart:io';
import 'package:login/authentication/module_choice/module_choice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login/user/user_main.dart';
import 'package:login/user/user_profile/edit_profile.dart';
import 'package:login/user/user_profile/qr_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  @override
  _ProfileSectionState createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<UserProfile> {
  File? _image;
  final _imageKey = 'selected_image';
  late Map<String, dynamic> addressItem;
  String _userName = '';
  String _userNumber = '';
  String _userEmail = '';
  User user = FirebaseAuth.instance.currentUser!; // Default user name

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
    _loadSavedImage();
  }

  Future<void> _loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString(_imageKey);
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  void _selectProfileImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _saveImageToPrefs(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _saveImageToPrefs(String imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imageKey, imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Profile',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: _selectProfileImage,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child: _image == null
                          ? Icon(Icons.add_a_photo, size: 50)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.black54,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Center(
                          child: Text(
                            _userName,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            QRCodeGen(userId: user.uid.toString())));
                  },
                  icon: Icon(
                    Icons.qr_code,
                    size: 60,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 20),
            color: Color.fromARGB(255, 241, 246, 251),
            child: ListTile(
              title: Text(
                'Name: $_userName',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color.fromARGB(255, 19, 11, 61),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Number: $_userNumber',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      color: Color.fromARGB(255, 19, 11, 61),
                    ),
                  ),
                  Text(
                    'Email: $_userEmail',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      color: Color.fromARGB(255, 19, 11, 61),
                    ),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Color.fromARGB(255, 19, 11, 61),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrgDetails(
                        setProfileItem: setProfileItem,
                        profileItem: {
                          'name': _userName,
                          'number': _userNumber,
                          'email': _userEmail,
                        },
                      ),
                    ),
                  ).then((updatedData) {
                    if (updatedData != null) {
                      setState(() {
                        _userName = updatedData['name'] ?? '';
                        _userNumber = updatedData['number'] ?? '';
                        _userEmail = updatedData['email'] ?? '';
                        _saveUserDetails();
                      });
                    }
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildProfileItem(
            icon: Icons.notifications_outlined,
            label: 'Pause Notifications',
            onPressed: () {
              helo(context);
            },
          ),
          SizedBox(height: 20),
          _buildProfileItem(
            icon: Icons.settings,
            label: 'Preferences',
            onPressed: () {
              helo(context);
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _logOut,
            child: Text('Log Out'),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(60, 50),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(icon),
            Text(label),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  void setProfileItem(Map<String, dynamic> item) {
    addressItem = item;
  }

  Future<void> _loadUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? '';
      _userNumber = prefs.getString('userNumber') ?? '';
      _userEmail = prefs.getString('userEmail') ?? '';
    });
  }

  Future<void> _saveUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userName', _userName);
    prefs.setString('userNumber', _userNumber);
    prefs.setString('userEmail', _userEmail);
  }

  void helo(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScreenHome()),
    );
  }

  void _logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => ModuleChoice()),
      (route) => false,
    );
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('User has been logged out successfully!'),
        backgroundColor: Colors.deepPurple));
  }
}
