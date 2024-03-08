import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {

  final String label;
  final double width;
  final Function(BuildContext)? onButtonPressed;

  const CustomButton({super.key, required this.label, this.onButtonPressed, this.width = 340});

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: widget.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4F2E22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(29),
            side: const BorderSide(color: Color(0xFFFFD384)),
          ),
        ),
        onPressed: () {
          if (widget.onButtonPressed != null) {
            widget.onButtonPressed!(context);
          }
        },
        child: Text(
          widget.label,
          style: const TextStyle(
              color: Color(0xFFFFF1CC),
              // fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
