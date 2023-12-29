import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  const CustomTextField({super.key, required this.controller, required this.label, required this.hint});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 50,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          fillColor: const Color(0xFFDFDFDF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide:
            const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide:
            const BorderSide(color: Colors.black),
          ),
          hintText: widget.hint,
          hintStyle: const TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
          hintMaxLines: 1,
          labelText: widget.label,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),
        ),
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}

class CustomTextFieldWithIcon extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final Icon icon;
  final Function(BuildContext)? onIconTap;

  const CustomTextFieldWithIcon(
      {super.key, required this.controller, required this.label, required this.hint, required this.icon, required this.onIconTap});

  @override
  State<CustomTextFieldWithIcon> createState() =>
      _CustomTextFieldWithIconState();
}

class _CustomTextFieldWithIconState extends State<CustomTextFieldWithIcon> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 50,
      child: TextField(
        controller: widget.controller,
        decoration: InputDecoration(
          fillColor: const Color(0xFFDFDFDF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide:
            const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide:
            const BorderSide(color: Colors.black),
          ),
          hintText: widget.hint,
          hintStyle: const TextStyle(
            fontSize: 16.0,
            color: Colors.grey,
          ),
          hintMaxLines: 1,
          labelText: widget.label,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),
          suffixIcon: IconButton(onPressed: () {
            if (widget.onIconTap != null) {
              widget.onIconTap!(context);
            }
          }, icon: widget.icon),
        ),
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
