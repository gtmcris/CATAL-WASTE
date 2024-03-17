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
        title: Text('Select Date'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Selected Waste Categories:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurpleAccent,
              ),
            ),
            SizedBox(height: 8),
            // Display selected waste categories
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.selectedCategories.entries.map((entry) {
                final category = entry.key;
                final subcategories = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...subcategories
                        .map((subcategory) => Text("- $subcategory"))
                        .toList(), // Added toList() to fix error
                  ],
                );
              }).toList(),
            ),
            SizedBox(height: 24),
            Text(
              "Please select a date for waste collection:",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
            // If month and year are same, update the existing data
            await scheduleCollection.doc(userId).update(userData);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Waste collection updated successfully')),
            );
          } else {
            // If month and year are different, create a new document
            await scheduleCollection.doc(userId).set(userData);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('New waste collection scheduled successfully')),
            );
          }
        } else {
          // If document doesn't exist, create a new one
          await scheduleCollection.doc(userId).set(userData);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Waste collection Setted successfully')),
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
          SnackBar(content: Text('Pincode is missing in the address data')),
        );
      }
    } catch (error) {
      // Show error message if any error occurs during scheduling
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scheduling waste collection: $error')),
      );
    }
  }
}
