import 'package:flutter/material.dart';
import 'package:notify/core/app_colors.dart';

class AppTextFieldItem extends StatelessWidget {
  const AppTextFieldItem({
    super.key,
    this.controller,
    this.hint,
    this.onPressed,
    this.trailingIcon,
  });

  final TextEditingController? controller;
  final VoidCallback? onPressed;
  final Widget? trailingIcon;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      onTap: onPressed,
      readOnly: onPressed != null,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.primary800,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey600),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey600),
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.grey400,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: trailingIcon,
      ),
      style: TextStyle(
        color: AppColors.grey100,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
