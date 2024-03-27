import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatePickerPage extends StatefulWidget {
  final Map<String, List<String>> selectedCategories;
  final Map<String, dynamic>? addressItem;

  const DatePickerPage({
    required this.selectedCategories,
    required this.addressItem,
  });

  @override
  _DatePickerPageState createState() => _DatePickerPageState();
}

class _DatePickerPageState extends State<DatePickerPage> {
  late DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.white),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Select Date', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 21, 24, 29),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Selected Waste Categories:",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              // Display selected waste categories
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: widget.selectedCategories.entries.map((entry) {
                  final category = entry.key;
                  final subcategories = entry.value;
                  return Card(
                    color: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          ...subcategories
                              .map((subcategory) => Text(
                                    "- $subcategory",
                                    style: TextStyle(color: Colors.white),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 24),
              Text(
                "Please select a date for waste collection:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  // Show date picker dialog
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );
                  // Update selected date if user picked one
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: Text('Select Date'),
              ),
              SizedBox(height: 16),
              Text(
                'Selected Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Perform action to schedule waste collection
                  _scheduleWasteCollection();
                },
                child: Text("Schedule Waste Collection"),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 21, 24, 29),
    );
  }

  void _scheduleWasteCollection() async {
    try {
      // Get the pincode from the addressItem
      final String? pincode = widget.addressItem?['Pincode'];

      // Check if the pincode is available
      if (pincode != null) {
        // Create a Firestore reference to the "schedule" collection
        final CollectionReference<Map<String, dynamic>> scheduleCollection =
            FirebaseFirestore.instance.collection('schedule');

        // Get the current user's ID
        final String userId =
            FirebaseAuth.instance.currentUser?.uid ?? 'Unknown';

        // Format the selected date
        final String formattedDate =
            DateFormat('yyyy-MM-dd').format(_selectedDate);

        // Construct the data to be updated
        final Map<String, dynamic> userData = {
          'selectedCategories': widget.selectedCategories,
          'selectedAddress': widget.addressItem,
          'selectedDate': formattedDate,
        };

        // Check if the collection for the formatted date already exists
        final DocumentSnapshot<Map<String, dynamic>> scheduleSnapshot =
            await scheduleCollection.doc(userId).get();

        if (scheduleSnapshot.exists) {
          final String existingDate =
              scheduleSnapshot.data()?['selectedDate'] ?? '';

          if (DateFormat('yyyy-MM').format(_selectedDate) ==
              DateFormat('yyyy-MM').format(DateTime.parse(existingDate))) {
            // If month and year are same , update the existing data
            await scheduleCollection.doc(userId).update(userData);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Waste collection updated successfully',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          } else {
            // If month and year are different, create a new document
            await scheduleCollection.doc(userId).set(userData);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'New waste collection scheduled successfully',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }
        } else {
          // If document doesn't exist, create a new one
          await scheduleCollection.doc(userId).set(userData);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Waste collection Set successfully',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        // Update the collection interSchedule
        await FirebaseFirestore.instance
            .collection('interSchedule')
            .doc(pincode)
            .collection(formattedDate)
            .doc(userId)
            .set({
          'selectedCategories': widget.selectedCategories,
          'selectedAddress': widget.addressItem,
        });
      } else {
        // Show error message if pincode is not available
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pincode is missing in the address data',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } catch (error) {
      // Show error message if any error occurs during scheduling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error scheduling waste collection: $error',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
