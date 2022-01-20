import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_stack_firebase_problem/screens/home_screen.dart';
import 'package:dev_stack_firebase_problem/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _isPasswordMoreSevenCharacters = false;
  bool _isPasswordMatch = false;
  bool _isVisibleConfirmPass = false;
  bool _isVisiblePass = false;

  onConfirmPasswordChanged(String password) {
    setState(() {
      _isPasswordMatch = false;
      if (password == passwordController.text) {
        _isPasswordMatch = true;
      }
    });
  }

  passwordContainsChars(String password) {
    setState(() {
      _isPasswordMoreSevenCharacters = false;
      if (password.length > 6) {
        _isPasswordMoreSevenCharacters = true;
      }
    });
  }

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
                // PasswordTextField(passwordController: passwordController),
                passwordTextField(),
                const SizedBox(
                  height: 5,
                ),
                confirmPasswordTextField(),
                const SizedBox(
                  height: 15,
                ),
                lengthOfPasswordCheck(),
                const SizedBox(
                  height: 10,
                ),
                confirmPasswordCheck(),
                const SizedBox(
                  height: 20,
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

  Row confirmPasswordCheck() {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: _isPasswordMatch ? Colors.green : Colors.transparent,
            border: _isPasswordMatch
                ? Border.all(color: Colors.transparent)
                : Border.all(color: Colors.grey.shade400),
          ),
          child: const Center(
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Text('Passwords don\'t match')
      ],
    );
  }

  Row lengthOfPasswordCheck() {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: _isPasswordMoreSevenCharacters
                  ? Border.all(color: Colors.transparent)
                  : Border.all(color: Colors.grey.shade400),
              color: _isPasswordMoreSevenCharacters
                  ? Colors.green
                  : Colors.transparent),
          child: const Center(
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Text('Password contains at least 7 characters')
      ],
    );
  }

  TextField confirmPasswordTextField() {
    return TextField(
      controller: confirmPasswordController,
      obscureText: !_isVisibleConfirmPass,
      onChanged: (value) => onConfirmPasswordChanged(value),
      decoration: InputDecoration(
        hintText: 'Confirm password',
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isVisibleConfirmPass = !_isVisibleConfirmPass;
              });
            },
            icon: _isVisibleConfirmPass
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off)),
      ),
    );
  }

  TextField passwordTextField() {
    return TextField(
      controller: passwordController,
      obscureText: !_isVisiblePass,
      onChanged: (value) => passwordContainsChars(value),
      decoration: InputDecoration(
          hintText: 'Password',
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _isVisiblePass = !_isVisiblePass;
              });
            },
            icon: _isVisiblePass
                ? const Icon(Icons.visibility)
                : const Icon(Icons.visibility_off),
          )),
    );
  }
}

class RegisterButton extends StatefulWidget {
  const RegisterButton(
      {Key? key,
      required this.formKey,
      required this.emailController,
      required this.passwordController})
      : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  State<RegisterButton> createState() => _RegisterButtonState();
}

class _RegisterButtonState extends State<RegisterButton> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ElevatedButton(
            onPressed: () async {
              final form = widget.formKey.currentState!;
              if (form.validate()) {
                try {
                  setState(() {
                    loading = true;
                  });
                  register(context, widget.emailController.text,
                      widget.passwordController.text);
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
              }
            },
            child: const Text('Register'));
  }

  void register(BuildContext context, String email, String password) async {
    await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((result) {
      firestoreInstance
          .collection(result.user!.uid)
          .add({'email': email, 'password': password}).then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(uid: result.user!.uid)),
            ((Route<dynamic> route) => false));
      });
    });
  }
}
