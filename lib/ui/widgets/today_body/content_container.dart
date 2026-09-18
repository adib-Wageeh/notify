import 'package:flutter/material.dart';
import 'package:notify/core/app_colors.dart';

class ContentContainer extends StatelessWidget {
  const ContentContainer({
    super.key,
    required this.content,
    this.containerColor,
  });

  final Widget content;
  final Color? containerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: containerColor ?? AppColors.primary800,
      ),
      padding: EdgeInsets.all(12),
      child: content,
    );
  }
}
