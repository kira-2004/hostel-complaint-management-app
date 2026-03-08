import 'package:flutter/material.dart';
import 'new_complaint_categories_screen.dart';

class ComplaintOptionsScreen extends StatelessWidget {
  final String category;

  const ComplaintOptionsScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$category Complaints")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NewComplaintCategoriesScreen(),
                  ),
                );
              },
              child: const Text("Write a New Complaint"),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
