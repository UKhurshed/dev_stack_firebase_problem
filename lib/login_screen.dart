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
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithEmail(String email, String password) async {
    final userLogin = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return userLogin.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
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

class LoginButton extends StatefulWidget {
  LoginButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 18));
    return loading
        ? const Center(child: CircularProgressIndicator())
        : ElevatedButton(
            onPressed: () async {
              try {
                setState(() {
                  loading = true;
                });
                await widget.firebaseAuth
                    .signInWithEmailAndPassword(
                        email: widget.emailController.text,
                        password: widget.passwordController.text)
                    .then((value) {
                  return Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen(uid: value.user!.uid)),
                      (Route<dynamic> route) => false);
                });
              } on FirebaseAuthException catch (error) {
                setState(() {
                  loading = false;
                });
                debugPrint(
                    'Error FirebaseAuth: ${error.message} and ${error.code}');
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: SizedBox(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Error ${error.message}'),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Close')),
                                ],
                              ),
                            )),
                      );
                    });
              }
            },
            child: const Text('Login'),
            style: style,
          );
  }
}
