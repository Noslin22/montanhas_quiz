import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Field extends StatelessWidget {
  const Field({
    Key? key,
    this.onComplete,
    required this.validator,
    required this.action,
    this.focus,
    required this.label,
    required this.type,
    this.onSaved,
    this.showError = true,
    this.obscure = false,
    this.suffix,
    this.value,
    this.onTap, this.onChanged,
  }) : super(key: key);

  final FocusNode? focus;
  final String label;
  final String? Function(String?) validator;
  final VoidCallback? onComplete;
  final void Function(String?)? onChanged;
  final TextInputAction action;
  final TextInputType type;
  final bool showError;
  final Widget? suffix;
  final Function(String?)? onSaved;
  final bool obscure;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focus,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: type,
      validator: validator,
      onTap: onTap,
      readOnly: onTap != null ? true : false,
      textInputAction: action,
      onEditingComplete: onComplete,
      style: GoogleFonts.roboto(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      controller: value != null ? TextEditingController(text: value) : null,
      obscureText: obscure,
      onChanged: onChanged,
      onSaved: onSaved,
      decoration: InputDecoration(
        labelText: "$label:",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorStyle: showError ? null : const TextStyle(height: 0),
        suffixIcon: suffix,
      ),
    );
  }
}
