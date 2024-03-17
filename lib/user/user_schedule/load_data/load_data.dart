import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoadUserData extends StatefulWidget {
  late User? user;
  final Function(int) setSelectedIndex;
  final Function(Map<String, dynamic>) setAddressItem;

  LoadUserData({
    super.key,
    required this.user,
    required this.setSelectedIndex,
    required this.setAddressItem,
  });

  @override
  _LoadUserDataState createState() => _LoadUserDataState();
}

class _LoadUserDataState extends State<LoadUserData> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('UserAddress')
          .doc(widget.user!.uid)
          .collection('Addresses')
          .doc('address')
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(
            child: Text('No Address found'),
          );
        }

        final data = snapshot.data!.data();
        if (data == null) {
          return Center(
            child: Text('Data is empty'),
          );
        }

        if (data is Map<String, dynamic>) {
          // Check if 'data' is a Map
          final arrayValues = data['a'];
          if (arrayValues is List<dynamic>) {
            // Check if 'a' is a list
            if (arrayValues.isEmpty) {
              return Center(
                child: Text('Array field "a" is empty'),
              );
            }

            return ListView.builder(
              itemCount: arrayValues.length,
              itemBuilder: (context, index) {
                final item = arrayValues[index] as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    widget.setSelectedIndex(index);
                    widget.setAddressItem(item);
                  },
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedIndex == index
                            ? Colors.deepPurple
                            : Colors.grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Text(
                        item["Address"].toString(),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      subtitle: Row(
                        children: [
                          Text(
                            "${item["Landmark"]},",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                          const SizedBox(width: 8), // Add some space
                          Text(
                            item["Pincode"].toString(),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteAddress(context, index);
                        },
                      ),
                      selected: _selectedIndex == index,
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(
                'Array field "a" is not a list',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        } else {
          return Center(
            child: Text(
              'Data is not in the expected format',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      },
    );
  }

  Future<void> _deleteAddress(BuildContext context, int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this address?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                try {
                  DocumentSnapshot snapshot = await FirebaseFirestore.instance
                      .collection('UserAddress')
                      .doc(widget.user!.uid)
                      .collection('Addresses')
                      .doc('address')
                      .get();

                  if (snapshot.exists) {
                    Map<String, dynamic> data =
                        snapshot.data() as Map<String, dynamic>;
                    List<dynamic> arrayValues = data['a'];

                    // Remove the item at the specified index
                    arrayValues.removeAt(index);

                    // Update the document with the modified array
                    await FirebaseFirestore.instance
                        .collection('UserAddress')
                        .doc(widget.user!.uid)
                        .collection('Addresses')
                        .doc('address')
                        .update({'a': arrayValues});

                    // Reload the screen after successful deletion

                    // Show SnackBar after successful deletion
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Address deleted successfully')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Document does not exist')),
                    );
                  }
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete address: $error')),
                  );
                } finally {
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
