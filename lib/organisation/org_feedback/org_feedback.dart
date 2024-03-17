import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter your feedback:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            // Text area for entering feedback
            TextField(
              controller: _feedbackController,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Type your feedback here...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            // Submit button
            ElevatedButton(
              onPressed: () {
                // Add code to submit feedback
                _submitFeedback();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to submit feedback
  void _submitFeedback() {
    // Get the entered feedback
    String feedback = _feedbackController.text;

    // Add code to submit feedback to backend or perform any other action
    // For now, just print the feedback
    print('Feedback submitted: $feedback');

    // Show a confirmation dialog or message to the user
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Feedback Submitted'),
          content: Text('Thank you for your feedback!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    // Clear the feedback text field
    _feedbackController.clear();
  }

  @override
  void dispose() {
    // Dispose the feedback controller when the widget is disposed
    _feedbackController.dispose();
    super.dispose();
  }
}
