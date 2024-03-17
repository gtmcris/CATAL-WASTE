import 'package:flutter/material.dart';
import 'package:login/organisation/org_feedback/org_feedback.dart';
import 'package:login/organisation/org_home/org_home.dart';
import 'package:login/organisation/org_pickup/org_pickup.dart';
import 'package:login/organisation/org_profile/org_profile.dart';
import 'package:login/organisation/org_schedule/org_schedule.dart';

class OrgMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Schedule Request App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OrgScreen(),
    );
  }
}

class OrgScreen extends StatefulWidget {
  @override
  _OrgScreenState createState() => _OrgScreenState();
}

class _OrgScreenState extends State<OrgScreen> {
  int _selectedIndex = 0;

  List<Widget> _screens = [
    HomeDetails(),
    ScheduleScreen(),
    PickupScreen(),
    FeedbackScreen(),
    OrgDetails(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catalyzing Change'),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Pickup',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Organization',
          )
        ],
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey, // Set the default color of the icons
        backgroundColor: Colors.grey,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Home Screen Content'),
//     );
//   }
// }



