import 'package:dev_stack_firebase_problem/home_screen.dart';
import 'package:dev_stack_firebase_problem/register_screen.dart';
import 'package:dev_stack_firebase_problem/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
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
                LoginButton(
                    formKey: formKey,
                    emailController: emailController,
                    passwordController: passwordController),
                const SizedBox(
                  height: 5,
                ),
                const RegisterButton()
                // EmailTextField(controller: passwordController),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 18));
    return ElevatedButton(
      style: style,
      onPressed: () => Navigator.push(
          context, MaterialPageRoute(builder: (context) => RegisterScreen())),
      child: const Text('Register'),
    );
  }
}

class LoginButton extends StatelessWidget {
  LoginButton({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 18));
    return ElevatedButton(
      onPressed: () {
        final form = formKey.currentState!;
        if (form.validate()) {
          final email = emailController.text;
          final password = passwordController.text;

          firebaseAuth
              .signInWithEmailAndPassword(email: email, password: password)
              .then((result) => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return HomeScreen(
                      uid: result.user!.uid,
                    );
                  })));
        }
      },
      style: style,
      child: const Text('Login'),
    );
  }
}
