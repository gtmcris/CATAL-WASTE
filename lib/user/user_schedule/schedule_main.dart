import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/user/user_schedule/user_schedule.dart';

class ScheduleMain extends StatefulWidget {
  @override
  _WasteCollectionDetailsPageState createState() =>
      _WasteCollectionDetailsPageState();
}

class _WasteCollectionDetailsPageState extends State<ScheduleMain> {
  late Stream<DocumentSnapshot> collectionStream;

  @override
  void initState() {
    super.initState();
    loadWasteCollectionDetails();
  }

  void loadWasteCollectionDetails() {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? 'Unknown';
    collectionStream = FirebaseFirestore.instance
        .collection('schedule')
        .doc(userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            leading: CircleAvatar(
              radius: 5,
              backgroundImage: AssetImage(
                'assets/images/logo/logo.png',
              ),
            ),
            title: Text(
              "Schedule",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            backgroundColor: Color.fromARGB(255, 21, 24, 29)),
        backgroundColor: Color.fromARGB(255, 21, 24, 29),
        body: StreamBuilder<DocumentSnapshot>(
          stream: collectionStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No data available'));
            }

            final DocumentSnapshot data = snapshot.data!; // Adjusted type here
            if (!data.exists) {
              return Center(child: Text('No data available'));
            }

            final selectedCategories =
                data['selectedCategories'] as Map<String, dynamic>? ?? {};
            final selectedAddress =
                data['selectedAddress'] as Map<String, dynamic>? ?? {};

            final selectedDateStr = data['selectedDate'] as String?;
            DateTime? selectedDateTime;

            if (selectedDateStr != null) {
              selectedDateTime = DateTime.parse(selectedDateStr);
            }
            final selectedDate = selectedDateTime != null
                ? Timestamp.fromDate(selectedDateTime)
                : null;

            if (selectedDate != null) {
              final formattedDate =
                  DateFormat('yyyy-MM-dd').format(selectedDate.toDate());

              return Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "The Current Schedule",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(
                            'Scheduled Date: $formattedDate',
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selected Waste Categories:',
                                style: TextStyle(color: Colors.white),
                              ),
                              if (selectedCategories.isNotEmpty)
                                ...selectedCategories.entries
                                    .map((entry) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              entry.key,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            ...((entry.value as List<dynamic>)
                                                .map((subcategory) => Text(
                                                      '- $subcategory',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ))
                                                .toList()),
                                          ],
                                        ))
                                    .toList(),
                              Text(
                                'Address: ${selectedAddress['Address'] ?? 'Not available'}',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              );
            } else {
              // Handle case where selectedDate is null
              return ListTile(
                title: Text('Error: Selected date not found'),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => UserSchedule(),
              ),
            );
          },
          label: Text('Add OR Update Schedule'),
          icon: Icon(Icons.add),
          backgroundColor: Color.fromARGB(255, 238, 238, 228),
        ),
      ),
    );
  }
}
