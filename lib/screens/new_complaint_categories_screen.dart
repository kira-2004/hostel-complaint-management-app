import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'student_login_screen.dart';
import 'complaint_form_screen.dart';

class NewComplaintCategoriesScreen extends StatelessWidget {
  const NewComplaintCategoriesScreen({super.key});

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const StudentLoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      "WiFi",
      "Sanitary",
      "Electrical",
      "Carpentry",
      "Others",
    ];

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(title: const Text("Select Complaint Category")),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var category in categories)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ComplaintFormScreen(category: category),
                        ),
                      );
                    },
                    child: Text(category),
                  ),
                ),

              const Spacer(),

              Align(
                alignment: Alignment.bottomLeft,
                child: TextButton.icon(
                  onPressed: () => logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
