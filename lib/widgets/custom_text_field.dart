import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool expand;

  const CustomTextField({super.key, required this.controller, required this.label, required this.hint, required this.expand});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      // height: 50,
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
        maxLines: widget.expand ? null : 1,
        minLines: 1,
      ),
    );
  }
}

class CustomTextFieldWithIcon extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final Icon icon;
  final bool expand;
  final Function(BuildContext)? onIconTap;
  final TextInputType keyboardType;

  const CustomTextFieldWithIcon(
      {super.key, required this.controller, required this.label, required this.hint, required this.icon, required this.expand, required this.onIconTap, required this.keyboardType});

  @override
  State<CustomTextFieldWithIcon> createState() =>
      _CustomTextFieldWithIconState();
}

class _CustomTextFieldWithIconState extends State<CustomTextFieldWithIcon> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      // height: 50,
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
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
        maxLines: widget.expand ? null : 1,
        minLines: 1,
      ),
    );
  }
}
