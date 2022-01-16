import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_stack_firebase_problem/home_screen.dart';
import 'package:dev_stack_firebase_problem/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                EmailTextFormField(
                  controller: emailController,
                ),
                const SizedBox(
                  height: 5,
                ),
                PasswordTextField(passwordController: passwordController),
                const SizedBox(
                  height: 10,
                ),
                RegisterButton(
                    formKey: formKey,
                    emailController: emailController,
                    passwordController: passwordController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  RegisterButton(
      {Key? key,
      required this.formKey,
      required this.emailController,
      required this.passwordController})
      : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          final form = formKey.currentState!;
          if (form.validate()) {
            register(context, emailController.text, passwordController.text);
          }
        },
        child: const Text('Register'));
  }

  void register(BuildContext context, String email, String password) {
    firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((result) {
      firestoreInstance
          .collection(result.user!.uid)
          .add({'email': email, 'password': password}).then((value) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      uid: result.user!.uid,
                    )));
      });
    });
  }
}
