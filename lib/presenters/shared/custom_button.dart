import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Function() _onPressed;
  final String _label;

  const CustomButton({
    required Function() onPressed,
    required String label,
  })  : _onPressed = onPressed,
        _label = label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: _onPressed,
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth / 2,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(_label),
        ),
      ),
    );
  }
}
