import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider/theme_color.dart';

class TextFieldComponents extends StatelessWidget {
  TextFieldComponents({
    super.key,
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.name,
    this.maxLength = 0,
    this.onchange,
  });
  String label;
  TextEditingController controller;
  TextInputType keyboardType;
  int maxLength;
  Function? onchange;
  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeColorProvider>();

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
            onChanged: (value) {
              if (onchange != null) {
                onchange!(value);
              }
            },
            maxLength: maxLength > 0 ? maxLength : null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: theme.primary,
                ),
              ),
              border: const OutlineInputBorder(
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
