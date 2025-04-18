import 'package:flutter/material.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';

class LoginInput extends StatefulWidget {
  const LoginInput({
    super.key,
    required this.controller,
    required this.labelText,
    required this.isPassword,
  });

  final TextEditingController controller;
  final String labelText;
  final bool isPassword;

  @override
  _LoginInputState createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: AppColors.primaryColor,
      style: const TextStyle(
        fontFamily: AppStrings.fontName,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.0,
          ),
        ),
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          color: AppColors.primaryColor,
          fontFamily: AppStrings.fontName,
          fontWeight: FontWeight.w300,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: AppColors.primaryColor,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : null,
      ),
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppStrings.fieldRequired;
        }
        return null;
      },
    );
  }
}
