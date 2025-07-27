import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final Widget icon;

  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.icon,

    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [icon, const SizedBox(width: 8.0)],
      ),
    );
  }
}
