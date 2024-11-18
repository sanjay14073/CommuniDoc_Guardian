import 'package:flutter/material.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text(
          "Help & Feedback",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to our Help & Feedback Section!",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "If you have any questions or issues, feel free to contact our support team.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement the functionality to contact support
                // For example, you can navigate to a contact form or open an email compose screen.
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
              ),
              child: Text("Contact Support", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 16),
            Text(
              "Your feedback is valuable to us. Please share your thoughts!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement the functionality to provide feedback
                // For example, you can navigate to a feedback form or open an email compose screen.
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.teal,
              ),
              child: Text("Provide Feedback", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
