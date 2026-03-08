import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'staff_login_screen.dart';

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const StaffLoginScreen()),
      (route) => false,
    );
  }

  Future<void> markResolved(String complaintId) async {
    await FirebaseFirestore.instance
        .collection("complaints")
        .doc(complaintId)
        .update({"status": "resolved", "resolvedAt": Timestamp.now()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Staff Dashboard")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("complaints").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final complaints = snapshot.data!.docs;
          print("Complaints Count: ${complaints.length}");

          if (complaints.isEmpty) {
            return const Center(child: Text("No complaints yet"));
          }

          return ListView(
            children: complaints.map((doc) {
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data["category"] ?? "No Category"),
                subtitle: Text(data["description"] ?? "No Description"),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
