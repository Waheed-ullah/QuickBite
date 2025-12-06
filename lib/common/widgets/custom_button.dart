import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isLoading;
  final bool outlined;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double? width;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.isLoading = false,
    this.outlined = false,
    this.borderRadius = 8,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width,
      child: MaterialButton(
        onPressed: isLoading ? null : onPressed,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: outlined
              ? BorderSide(color: backgroundColor ?? theme.primaryColor)
              : BorderSide.none,
        ),
        color: outlined
            ? Colors.transparent
            : backgroundColor ?? theme.primaryColor,
        disabledColor: (backgroundColor ?? theme.primaryColor).withOpacity(0.5),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor ?? Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: 20,
                      color: outlined
                          ? backgroundColor ?? theme.primaryColor
                          : textColor ?? Colors.white,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: outlined
                          ? backgroundColor ?? theme.primaryColor
                          : textColor ?? Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
