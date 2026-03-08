import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ComplaintDetailScreen extends StatefulWidget {
  final String complaintId;
  final String category;
  final String status;
  final String role; // ADD THIS

  const ComplaintDetailScreen({
    super.key,
    required this.complaintId,
    required this.category,
    required this.status,
    required this.role, // ADD THIS
  });

  @override
  State<ComplaintDetailScreen> createState() => _ComplaintDetailScreenState();
}

class _ComplaintDetailScreenState extends State<ComplaintDetailScreen> {
  final TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;

    if (messageController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection("complaints")
        .doc(widget.complaintId)
        .collection("messages")
        .add({
          "senderRole": widget.role, // we’ll adjust later
          "senderId": user!.uid,
          "text": messageController.text.trim(),
          "createdAt": Timestamp.now(),
        });

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("complaints")
                  .doc(widget.complaintId)
                  .collection("messages")
                  .orderBy("createdAt")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final data = messages[index].data();
                    final text = data["text"];
                    final sender = data["senderRole"];

                    final isStudent = sender == "student";

                    return Container(
                      alignment: isStudent
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isStudent
                              ? Colors.blue[100]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(text),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: "Type message...",
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
