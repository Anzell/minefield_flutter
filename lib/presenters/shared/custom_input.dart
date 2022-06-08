import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController _controller;

  CustomInput({required TextEditingController controller}) : _controller = controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
