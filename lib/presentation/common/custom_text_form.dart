import 'package:book/styles/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextForm extends StatefulWidget {
  const CustomTextForm(
      {required this.validator,
      required this.labelText,
      required this.keyboardType,
      required this.isNonPasswordField,
      Key? key,
      required this.maxLength,
      this.suffixIcon})
      : super(key: key);

  final bool isNonPasswordField;
  final String labelText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int maxLength;
  final Widget? suffixIcon;

  @override
  State<CustomTextForm> createState() => _CustomTextFormState();
}

class _CustomTextFormState extends State<CustomTextForm> {
  bool obscureText = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: widget.maxLength,
      obscureText: widget.isNonPasswordField ? false : !obscureText,
      validator: widget.validator,
      decoration: InputDecoration(
        suffixIcon: !widget.isNonPasswordField
            ? IconButton(
                onPressed: () {
                  toggleObscureText();
                },
                icon: widget.isNonPasswordField
                    ? Icon(null)
                    : !obscureText
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
              )
            : widget.suffixIcon,
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

  void toggleObscureText() {
    setState(() {
      obscureText = !obscureText;
    });
  }
}
