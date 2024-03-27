import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/user/user_schedule/booking/category_quantity.dart';
import 'package:login/user/user_schedule/new_address/u_s_newaddress.dart';
import 'package:login/user/user_schedule/load_data/load_data.dart';

class UserSchedule extends StatefulWidget {
  const UserSchedule({Key? key}) : super(key: key);

  @override
  _UserScheduleState createState() => _UserScheduleState();
}

class _UserScheduleState extends State<UserSchedule> {
  List<String> selectedCategories = [];
  User? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loadData = false;
  Map<String, dynamic> addressItem = {};
  int? _selectedIndex;

  void initState() {
    super.initState();

    // Listen for changes in user authentication state
    _auth.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });

      if (user != null) {
        loadData = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 21, 24, 29),
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(
          color: Colors.white, // Change this color to the desired color
        ), // Set background color
        backgroundColor: Color.fromARGB(255, 21, 24, 29),
        title: Text(
          'Select Schedule',
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            "Please Select an Address",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          Expanded(
            child: LoadUserData(
              user: _user,
              setSelectedIndex: setSelectedIndex,
              setAddressItem: setAddressItem,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: TextButton(
              onPressed: () {
                // Handle adding new address
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx1) => NewAddressForm()),
                );
              },
              child: Text(
                '+ Add new Address',
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Column(
            children: [
              Text(
                'Choose Waste Categories:',
                style: TextStyle(color: white(), fontSize: 20),
              ),
              _buildCategoryIconSelection(Icons.grass, 'Bio Waste'),
              _buildCategoryIconSelection(Icons.local_bar, 'Plastic'),
              _buildCategoryIconSelection(Icons.eco, 'Degradable'),
              _buildCategoryIconSelection(Icons.dangerous, 'Hazardous'),
            ],
          ),
          SizedBox(
              height:
                  16.0), // Add spacing between the categories and the Submit button
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              onPressed: () {
                // Handle Submit action
                // For example, you can print the selected categories
                print(addressItem);
                if (addressItem.isNotEmpty && selectedCategories.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          CategoryQuantity(selectedCategories, addressItem),
                    ),
                  );
                  print(selectedCategories);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Please Select an address and a waste category',
                    ),
                    backgroundColor: Colors.deepPurple,
                  ));
                }
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 252, 255, 228), // Background color
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 15), // Adjust vertical padding
                child: Text(
                  'CONFIRM',
                  style: TextStyle(
                    color: Color.fromARGB(255, 22, 14, 47), // Change font color
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIconSelection(IconData icon, String category) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: selectedCategories.contains(category)
                ? Colors.deepPurple // Change color if selected
                : Colors.grey, // Default color
          ),
          onPressed: () {
            setState(() {
              if (selectedCategories.contains(category)) {
                selectedCategories.remove(category);
              } else {
                selectedCategories.add(category);
              }
            });
          },
        ),
        Text(
          category,
          style: TextStyle(color: white()),
        ),
      ],
    );
  }

  void setAddressItem(Map<String, dynamic> item) {
    addressItem = item;
  }

  void setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

Color white() {
  return Colors.white;
}
