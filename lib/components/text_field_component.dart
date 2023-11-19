import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TextFieldComponents extends StatelessWidget {
  TextFieldComponents(
      {super.key,
      required this.label,
      required this.controller,
      this.keyboardType = TextInputType.name,
      this.maxLength = 0});
  String label;
  TextEditingController controller;
  TextInputType keyboardType;
  int maxLength;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: TextField(
            keyboardType: keyboardType,
            controller: controller,
            maxLength: maxLength > 0 ? maxLength : null,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
