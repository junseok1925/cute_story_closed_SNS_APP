import 'package:cute_story_closed_sns_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CsTextField extends StatelessWidget {
  final BuildContext context;
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  const CsTextField({
    super.key,
    required this.context,
    required this.controller,
    required this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        isDense: true, // 높이 줄이기
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        hintText: hint,
        filled: true,
        fillColor: vrc(context).background200,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: fxc(context).brandColor!, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: vrc(context).background200!, width: 2),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
