import 'package:dev_stack_firebase_problem/utils/extensions.dart';
import 'package:flutter/material.dart';

class EmailTextFormField extends StatelessWidget {
  final TextEditingController controller;
  const EmailTextFormField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      validator: (input) => input!.isValidEmail() ? null : 'Check your Email',
      decoration: const InputDecoration(labelText: 'Email'),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController passwordController;

  const PasswordTextField({Key? key, required this.passwordController})
      : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      obscureText: !_isVisible,
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value!.length < 4) {
          return 'Password too short';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isVisible = !_isVisible;
                });
              },
              icon: _isVisible
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off)),
          labelText: 'Password'),
    );
  }
}
