import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CriteriaInputField extends StatefulWidget {
  final TextEditingController textController1;
  final TextEditingController textController2;

  const CriteriaInputField({
    super.key,
    required this.textController1,
    required this.textController2,
  });

  @override
  State<CriteriaInputField> createState() => _CriteriaInputFieldState();
}

class _CriteriaInputFieldState extends State<CriteriaInputField> {
  dynamic formatter = FilteringTextInputFormatter.allow(RegExp(r'^\d+$'));
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _textField(
            textController: widget.textController1,
            label: 'criteria level',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a value';
              }
              final int? number = int.tryParse(value);
              if (number == null || number < 0 || number > 100) {
                return 'Enter a number between 0 and 100';
              }
              return null;
            },
            hintText: "input 0~100 integer",
          ),
          _textField(
              textController: widget.textController2,
              label: 'criteria time',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                final int? number = int.tryParse(value);
                if (number == null || number < 1 || number > 24) {
                  return 'Enter a number between 1 and 24';
                }
                return null;
              },
              hintText: "input 0~24 integer"),
        ],
      ),
    );
  }

  Widget _textField(
      {required textController,
      required label,
      required validator,
      required hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 4),
        SizedBox(
          width: MediaQuery.sizeOf(context).width * 0.3,
          child: TextFormField(
            controller: textController,
            decoration: InputDecoration(
              hintText: hintText,
              // labelText: widget.label,
              // labelStyle: TextStyle(fontSize: 24, color: Colors.black),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            validator: validator,
            inputFormatters: [formatter],
          ),
        ),
      ],
    );
  }
}
