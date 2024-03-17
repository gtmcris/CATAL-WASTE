import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String? pincode;
  late DateTime selectedDate;
  bool _isLoading = true;
  late User _user; // Added to track loading state

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!; // Get current user
    _getPincode();
    selectedDate = DateTime.now();
    print(selectedDate);
  }

  Future<void> _getPincode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pincode = prefs.getString('pincode'); // Set pincode after initialization
      _isLoading = false; // Set loading state to false after initialization
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _toggleSelection(DocumentReference documentRef,
      Map<String, dynamic> data, String userId) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Pickup'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Do you want to confirm the pickup for the following address?'),
                Text(
                  'Address: ${data['selectedAddress']['Address']}, Landmark: ${data['selectedAddress']['Landmark']}, Pincode: ${data['selectedAddress']['Pincode']}',
                ),
                Text(
                    'Selected Categories: ${data['selectedCategories'].values.join(', ')}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                // Update the "pickUp" collection
                DocumentSnapshot snapshot = await FirebaseFirestore.instance
                    .collection('pickUp')
                    .doc(_user.uid)
                    .get();
                    Map<String, dynamic> combinedData = {...data, 'userid': userId};

                if (snapshot.exists && snapshot.data() != null) {
                  // Document exists and contains data, update 'a' field
                  await FirebaseFirestore.instance
                      .collection('pickUp')
                      .doc(_user.uid)
                      .update({
                    'a': FieldValue.arrayUnion([
                      combinedData
                    ])
                  });
                } else {
                  // Document does not exist or does not contain data, set 'a' field
                  await FirebaseFirestore.instance
                      .collection('pickUp')
                      .doc(_user.uid)
                      .set({
                    'a': FieldValue.arrayUnion([
                        combinedData
                    ])
                  });
                }
                // Delete the document from "interSchedule"
                await documentRef.delete();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSchedule() {
    if (pincode == null) {
      return Center(
        child: Text('No pincode available'),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('interSchedule')
          .doc(pincode!)
          .collection(DateFormat('yyyy-MM-dd').format(selectedDate))
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        // Data available, display it
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var document = snapshot.data!.docs[index];
              var data = document.data() as Map<String, dynamic>;
              var userId = document.id;
              // Extracting and labeling subtypes
              String selectedAddress =
                  'Address: ${data['selectedAddress']['Address']}, Landmark: ${data['selectedAddress']['Landmark']}, Pincode: ${data['selectedAddress']['Pincode']}';
              var selectedCategories = data['selectedCategories'];
              String selectedCategoriesString = selectedCategories is Map
                  ? selectedCategories.entries.map((entry) {
                      return "${entry.key}: ${entry.value.join(', ')}";
                    }).join('\n')
                  : 'Categories: Not Available';

              return GestureDetector(
                onTap: () => _toggleSelection(document.reference, data, userId),
                child: Card(
                  color: Colors.purpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selected Address:',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                selectedAddress,
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Selected Categories:',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                selectedCategoriesString,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          // Return a SizedBox with a minimum height
          return SizedBox(
            height: 100, // Adjust the height according to your UI requirements
            child: Center(
              child: Text('No data available'),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    'Select Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: _buildSchedule(),
              ),
            ],
          );
  }
}
