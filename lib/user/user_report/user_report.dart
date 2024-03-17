import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login/user/user_report/camera.dart';

class UserReport extends StatefulWidget {
  @override
  _UserReportState createState() => _UserReportState();
}

class _UserReportState extends State<UserReport> {
  List<String> _selectedWasteCollectionIssues = [];
  List<String> _selectedNeighbourhoodIssues = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 21, 24, 29),
          leading: CircleAvatar(
            radius: 5,
            backgroundImage: AssetImage(
              'assets/images/logo/logo.png',
            ),
          ),
          title: Text(
            "Report",
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 21, 24, 29),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Issues related to waste collection',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ..._getWasteCollectionIssues(),
              const SizedBox(height: 32),
              const Text(
                'Issues in the neighbourhood',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ..._getNeighbourhoodIssues(),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CameraPage()),
                    );
                  },
                  child: Text('If any other reason'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getWasteCollectionIssues() {
    List<Widget> issues = [];
    for (final issue in [
      'Overflowing bins',
      'Missed collections',
      'Littering',
      'Improper waste sorting',
      'Other (please specify)',
    ]) {
      final localIssue = issue;
      issues.add(
        _buildIssueCheckbox(localIssue, _selectedWasteCollectionIssues,
            (value) {
          setState(() {
            if (value!) {
              _selectedWasteCollectionIssues.add(issue);
            } else {
              _selectedWasteCollectionIssues.remove(issue);
            }
          });
        }),
      );
    }
    return issues;
  }

  List<Widget> _getNeighbourhoodIssues() {
    List<Widget> issues = [];
    for (final issue in [
      'Illegal Waste dumping',
      'Burning harmful waste (Green House gas emitters)',
    ]) {
      final localIssue = issue;
      issues.add(
        _buildIssueCheckbox(localIssue, _selectedNeighbourhoodIssues, (value) {
          setState(() {
            if (value!) {
              _selectedNeighbourhoodIssues.add(issue);
            } else {
              _selectedNeighbourhoodIssues.remove(issue);
            }
          });
        }),
      );
    }
    return issues;
  }

  Widget _buildIssueCheckbox(
    String issue,
    List<String> selectedIssues,
    void Function(bool?) onChangeValue,
  ) {
    return Row(
      children: [
        Checkbox(
          value: selectedIssues.contains(issue),
          onChanged: onChangeValue,
          activeColor: Color.fromARGB(255, 42, 3, 150),
          checkColor: Color.fromARGB(255, 255, 255, 255),
          side: BorderSide(color: Colors.grey),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        Expanded(
          child: Text(
            issue,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.white),
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}
