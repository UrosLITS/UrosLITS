import 'package:book/styles/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextForm extends StatefulWidget {
  const CustomTextForm(
      {required this.validator,
      required this.labelText,
      required this.keyboardType,
      this.isPasswordField = false,
      Key? key,
      required this.maxLength,
      this.suffixIcon,
      this.obscureText = false,
      required this.onChanged})
      : super(key: key);

  final bool isPasswordField;
  final String labelText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLength;
  final Widget? suffixIcon;
  final ValueChanged onChanged;

  final bool obscureText;

  @override
  State<CustomTextForm> createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: widget.maxLength,
      obscureText: widget.obscureText,
      validator: widget.validator,
      onChanged: (value) {
        widget.onChanged(value);
      },
      decoration: InputDecoration(
        suffixIcon: widget.suffixIcon,
        counterText: "",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.black, width: 1),
        ),
        alignLabelWithHint: true,
        labelStyle: TextStyle(color: AppColors.black),
        labelText: widget.labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppColors.grey,
            width: 1,
          ),
        ),
      ),
    );
  }
}
