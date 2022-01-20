import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_stack_firebase_problem/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key, required this.uid}) : super(key: key);

  final String uid;
  final firestoreInstance = FirebaseFirestore.instance;

  Future<QueryDocumentSnapshot<Object?>> getUserById() async {
    List<String> userDocsList = [];
    QuerySnapshot querySnapshot = await firestoreInstance.collection(uid).get();
    userDocsList.add(querySnapshot.docs.first.get('email'));
    userDocsList.add(querySnapshot.docs.first.get('password'));
    debugPrint(
        "Email: ${querySnapshot.docs.first.get('email')} Password: ${querySnapshot.docs.first.get('password')}");
    return querySnapshot.docs.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Flutter Login Demo'),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  auth.signOut().then((value) => {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                            (route) => false)
                      });
                },
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ))
          ],
        ),
        body: FutureBuilder<QueryDocumentSnapshot<Object?>>(
          future: getUserById(),
          builder: (context, snapshot) {
            final data = snapshot.data;

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Error occurred from fetching'),
                  );
                } else {
                  return Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        const Text(
                          'Welcome',
                          style: TextStyle(fontSize: 26),
                        ),
                        const SizedBox(
                          height: 70,
                        ),
                        Text('Email: ${data?.get('email')}'),
                        const SizedBox(
                          height: 5,
                        ),
                        Text('Password: ${data?.get('password')}')
                      ],
                    ),
                  );
                }
            }
          },
        ));
  }
}
