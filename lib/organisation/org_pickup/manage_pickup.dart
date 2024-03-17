import 'package:flutter/material.dart';
import 'package:login/organisation/org_pickup/scan_qr.dart';

class ManagePickup extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ManagePickup({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Pickup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Colors.purple[900]!, // Dark purple color
                  width: 2.0, // Border width
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Address:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text('Address: ${userData['selectedAddress']['address']}'),
                    Text(
                        'Landmark: ${userData['selectedAddress']['landmark']}'),
                    Text('Pincode: ${userData['selectedAddress']['pincode']}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Colors.purple[900]!, // Dark purple color
                  width: 2.0, // Border width
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Categories:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    Text(
                        'Category: ${userData['selectedCategories']['category']}'),
                    Text(
                        'Sub-Category: ${userData['selectedCategories']['subcategory']}'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'User ID:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('${userData['userid']}'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) =>
                    //             ScanCodePage(userId: userData['userid'])));
                  },
                  child: Text('Verify User'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement action for second button
                  },
                  child: Text('Give Credit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
