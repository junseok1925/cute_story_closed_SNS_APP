import 'package:cute_story_closed_sns_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CsButton extends StatelessWidget {
  final BuildContext context;
  final String text;
  final VoidCallback? onPressed;

  const CsButton({
    super.key,
    required this.context,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: fxc(context).brandColor,
          foregroundColor: vrc(context).background200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
