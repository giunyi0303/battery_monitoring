import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textController;
  final String? Function(String?)? validator;
  final String label;
  final String hintText;

  const CustomTextField(
      {super.key,
      required this.textController,
      required this.label,
      required this.validator,
      required this.hintText});

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  dynamic formatter = FilteringTextInputFormatter.allow(RegExp(r'^\d+$'));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label),
        const SizedBox(height: 4),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.3,
          child: TextFormField(
            controller: widget.textController,
            decoration: InputDecoration(
              hintText: widget.hintText,
              // labelText: widget.label,
              // labelStyle: TextStyle(fontSize: 24, color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            validator: widget.validator,
            inputFormatters: [formatter],
          ),
        ),
      ],
    );
  }
}
