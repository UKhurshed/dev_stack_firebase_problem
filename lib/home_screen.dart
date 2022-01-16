import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_stack_firebase_problem/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  String uid;

  HomeScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  String email = "";
  String password = "";

  @override
  void initState() {
    firestoreInstance.collection(widget.uid).get().then((value) {
      final docs = value.docs.first;
      setState(() {
        email = docs.get('email');
        password = docs.get('password');
      });
      debugPrint(
          "Email: ${docs.get('email')}, Password: ${docs.get('password')}");
    });
    super.initState();
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
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
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
              Text('Email: $email'),
              const SizedBox(
                height: 5,
              ),
              Text('Password: $password')
            ],
          ),
        ),
      ),
    );
  }
}
