import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:waste_manage/user_type.dart';


class ContributorDashboard extends StatefulWidget {
  const ContributorDashboard({Key? key});

  @override
  _ContributorDashboardState createState() => _ContributorDashboardState();
}

class _ContributorDashboardState extends State<ContributorDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  TextEditingController _solidWasteController = TextEditingController();
  TextEditingController _liquidWasteController = TextEditingController();

  Stream<DocumentSnapshot>? _contributorDataStream;

  double _solidWaste = 0; // Variable to hold solid waste data
  double _liquidWaste = 0; // Variable to hold liquid waste data

  @override
  void initState() {
    super.initState();

    // Listen for changes in user authentication state
    _auth.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });

      if (user != null) {
        _loadContributorData();
      }
    });
  }

  // void _signOut() async {
  //   try {
  //     await _auth.signOut();
  //     Navigator.popAndPushNamed(context, UserTypePage() as String);
  //   } catch (e) {
  //     print("Error signing out: $e");
  //   }
  // }

  Future<void> _loadContributorData() async {
    _contributorDataStream = _firestore
        .collection('contributors')
        .doc(_user!.uid)
        .snapshots();

    _contributorDataStream!.listen((snapshot) {
      if (snapshot.exists) {
        setState(() {
          _solidWaste = double.parse(snapshot['solidWaste'] ?? '0');
          _liquidWaste = double.parse(snapshot['liquidWaste'] ?? '0');
          _user!.updateDisplayName(snapshot['name'] ?? ''); // Update the user's display name
        });
      }
    });
  }

  void _submitWaste() async {
    final data = {
      'solidWaste': _solidWasteController.text,
      'liquidWaste': _liquidWasteController.text,
    };

    await _firestore.collection('contributors').doc(_user!.uid).set(
      data,
      SetOptions(merge: true),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Waste data submitted successfully')),
    );

    // Clear the input fields
    _solidWasteController.clear();
    _liquidWasteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contributor Dashboard')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_user?.displayName ?? ''}', // Use an empty string as a fallback
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                _user?.email ?? '',
                style: TextStyle(fontSize: 16),
              ),
              Row(
                children: [
                  Text('Solid Waste: $_solidWaste kg'),
                  SizedBox(width: 20),
                  Text('Liquid Waste: $_liquidWaste liters'),
                ],
              ),
              TextFormField(
                controller: _solidWasteController,
                decoration: InputDecoration(labelText: 'Solid Waste Input (in kg)'),
              ),
              TextFormField(
                controller: _liquidWasteController,
                decoration: InputDecoration(labelText: 'Liquid Waste Input (in liters)'),
              ),
              ElevatedButton(
                onPressed: _submitWaste,
                child: Text('Submit Waste'),
              ),
              // Rest of your widgets
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:()=>print("helo"),
        child: Icon(Icons.logout),
      ),
    );
  }
}
