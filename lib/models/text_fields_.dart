import 'package:flutter/material.dart';

class CustomTextFieldBuilder {
  Widget buildTextField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.white,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
