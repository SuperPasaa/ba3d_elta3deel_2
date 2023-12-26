import 'dart:async';

import 'package:flutter/material.dart';

class CustomConfirmationPasswordTextForm extends StatelessWidget {
  final String hinttext;
  final TextEditingController mycontroller;
  final IconData icon;
  final bool obsecureTe;
  final IconButton? iconButton;
  final IconData? suffIcon;
  final String? confirmPassword;

  const CustomConfirmationPasswordTextForm({
    super.key,
    required this.hinttext,
    required this.mycontroller,
    required this.icon,
    required this.obsecureTe,
    this.iconButton,
    this.suffIcon,
    this.confirmPassword,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "Field can not be empty";
        }
        if (value != confirmPassword) {
          return 'Confirm password do not match password';
        }
      },
      obscureText: obsecureTe,
      controller: mycontroller,
      decoration: InputDecoration(
          prefixIcon: Icon(icon),
          suffixIcon: iconButton,
          hintText: hinttext,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.black),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
          filled: true,
          fillColor: Colors.grey[200],
          border: const OutlineInputBorder(
              // borderRadius: BorderRadius.circular(50),
              borderSide:
                  BorderSide(color: Color.fromARGB(255, 184, 184, 184))),
          enabledBorder: const OutlineInputBorder(
              // borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide(color: Colors.grey))),
    );
  }
}
