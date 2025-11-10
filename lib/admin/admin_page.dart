import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference signupRef =
        FirebaseFirestore.instance.collection('signup_advisors');
    final CollectionReference approvedRef =
        FirebaseFirestore.instance.collection('approved_advisors');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin: View Advisors'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pending Advisors',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Pending advisors section
            StreamBuilder<QuerySnapshot>(
              stream: signupRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No pending advisors.');
                }

                final advisors = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: advisors.length,
                  itemBuilder: (context, index) {
                    final advisor = advisors[index];
                    final fName = advisor['first_name'];
                    final lName = advisor['last_name'];
                    final email = advisor['email'];
                    final password = advisor['password'];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text('$fName $lName'),
                        subtitle: Text(email),
                        trailing: ElevatedButton(
                          onPressed: () async {
                            try {
                              final userCredential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: email, password: password);
                              await userCredential.user!.updateDisplayName("$fName $lName");
                              await approvedRef.doc(userCredential.user!.uid).set({
                                'first_name': fName,
                                'last_name': lName,
                                'email': email,
                              });
                              await signupRef.doc(advisor.id).delete();

                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: ${e.message}')),
                              );
                            }
                          },
                          child: const Text('Approve'),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 24),

            // Approved advisors section
            const Text(
              'Approved Advisors',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: approvedRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No approved advisors yet.');
                }

                final approvedAdvisors = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: approvedAdvisors.length,
                  itemBuilder: (context, index) {
                    final advisor = approvedAdvisors[index];
                    final fName = advisor['first_name'];
                    final lName = advisor['last_name'];
                    final email = advisor['email'];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text('$fName $lName'),
                        subtitle: Text(email),
                        trailing: const Icon(Icons.check, color: Colors.green),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
