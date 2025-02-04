import 'package:flutter/material.dart';

class GradientTextField extends StatelessWidget {
  const GradientTextField({super.key,
  required this.controller,
  required this.style,
  required this.width,
  this.isMultiline = false,
  this.minLines = 1,
  this.maxLines = 1,
  this.hintText = "Enter text…",});

  final TextEditingController controller;
  final bool isMultiline;
  final TextStyle style;
  final double width;
  final String hintText;
  final int minLines;
  final int maxLines;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            minLines: isMultiline?null:minLines,
            maxLines: isMultiline?null:maxLines,
            expands: isMultiline,
            keyboardType: isMultiline?TextInputType.multiline:TextInputType.text,
            textAlignVertical: TextAlignVertical.top,
            style: style,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.white.withAlpha(113),
              ),
              filled: true,
              fillColor: Color(0xff333333).withAlpha(70),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Color(0xff424242), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Color(0xff424242), width: 1),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Color(0xff424242), width: 1),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
          ),
        ),
      ),
    );
  }
}