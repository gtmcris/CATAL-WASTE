import 'package:login/user/user_home/user_home.dart';
import 'package:login/user/user_profile/user_profile.dart';
import 'package:login/user/user_report/user_report.dart';
import 'package:login/user/user_schedule/schedule_main.dart';
import 'package:login/user/user_schedule/user_schedule.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

String activeContent = 'hello';
int _currentSelectedIndex = 0;
final _pages = [
  UserHome(),
  ScheduleMain(),
  UserReport(),
  UserProfile(),
];

class ScreenHome extends StatefulWidget {
  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 21, 24, 29),
      body: _pages[_currentSelectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 45, 49, 71), // Custom color
          borderRadius: BorderRadius.all(Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
              offset: Offset(0, 20),
              blurRadius: 20,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: SalomonBottomBar(
          currentIndex: _currentSelectedIndex,
          onTap: (int index) {
            setState(() {
              _currentSelectedIndex = index;
            });
          },
          items: [
            SalomonBottomBarItem(
              selectedColor: const Color.fromARGB(255, 58, 103, 252),
              unselectedColor: Color.fromARGB(255, 255, 255, 255),
              icon: const Icon(Icons.home),
              title: const Text("Home"),
            ),
            SalomonBottomBarItem(
              selectedColor: const Color.fromARGB(255, 58, 103, 252),
              unselectedColor: Color.fromARGB(255, 255, 255, 255),
              icon: const Icon(Icons.schedule_outlined),
              title: const Text("Schedule"),
            ),
            SalomonBottomBarItem(
              selectedColor: const Color.fromARGB(255, 58, 103, 252),
              unselectedColor: Color.fromARGB(255, 255, 255, 255),
              icon: const Icon(Icons.report),
              title: const Text("Report"),
            ),
            SalomonBottomBarItem(
              selectedColor: const Color.fromARGB(255, 58, 103, 252),
              unselectedColor: Color.fromARGB(255, 255, 255, 255),
              icon: const Icon(Icons.person_2),
              title: const Text("Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
