import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/organisation/org_pickup/manage_pickup.dart';

class PickupScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<PickupScreen> {
  late List<Map<String, dynamic>> pickupData = [];
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    loadPickupData();
  }

  Future<void> loadPickupData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('pickUp')
          .doc(_user.uid)
          .get();
      if (snapshot.data() != null) {
        Map<String, dynamic>? snapshotData =
            snapshot.data() as Map<String, dynamic>?;

        if (snapshotData != null && snapshotData.containsKey('a')) {
          List<Map<String, dynamic>> data = [];
          for (var item in snapshotData['a']) {
            data.add(Map<String, dynamic>.from(item));
          }
          setState(() {
            pickupData = data;
          });
        }
      }
    } catch (e) {
      print('Error loading pickup data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: pickupData.length,
        itemBuilder: (context, index) {
          var item = pickupData[index];
          return Card(
            color: Colors.deepPurple,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                'Address: ${item['selectedAddress']['Address']}',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Landmark: ${item['selectedAddress']['Landmark']}, Pincode: ${item['selectedAddress']['Pincode']}',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Handle item selection here
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
                                'Address: ${item['selectedAddress']['Address']}, Landmark: ${item['selectedAddress']['Landmark']}, Pincode: ${item['selectedAddress']['Pincode']}'),
                            Text(
                                'Selected Categories: ${item['selectedCategories'].values.join(', ')}'),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Confirm'),
                          onPressed: () {
                            // Handle confirmation actions
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ManagePickup(
                                      userData: item,
                                    )));
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
              },
            ),
          );
        },
      ),
    );
  }
}
