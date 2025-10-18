import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Future<void> Function()? onPressedAsync;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final double? width;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double? borderRadius;
  final bool isLoading;
  final bool useGradient;

  const CustomButton({
    super.key,
    this.text = '',
    this.onPressed,
    this.onPressedAsync,
    this.backgroundColor,
    this.textColor,
    this.height = 56,
    this.width = double.infinity,
    this.fontSize = 17,
    this.fontWeight = FontWeight.w700,
    this.borderRadius = 16,
    this.isLoading = false,
    this.useGradient = true, // Use gradient by default
  });

  @override
  Widget build(BuildContext context) {
    if (useGradient) {
      // Orange gradient button matching HomeScreen theme
      return GestureDetector(
        onTap: isLoading ? null : (onPressed ?? onPressedAsync),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            gradient: isLoading
                ? LinearGradient(
                    colors: [
                      const Color(0xFFFF6B3D).withOpacity(0.6),
                      const Color(0xFFFF8A5C).withOpacity(0.6),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : const LinearGradient(
                    colors: [Color(0xFFFF6B3D), Color(0xFFFF8A5C)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
            borderRadius: BorderRadius.circular(borderRadius!),
            boxShadow: isLoading
                ? []
                : [
                    BoxShadow(
                      color: const Color(0xFFFF6B3D).withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        textColor ?? Colors.white,
                      ),
                    ),
                  )
                : Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: textColor ?? Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      );
    } else {
      // Fallback to solid color button
      return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: isLoading ? null : (onPressed ?? onPressedAsync),
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? const Color(0xFFFF6B3D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius!),
            ),
            elevation: 0,
            disabledBackgroundColor: (backgroundColor ?? const Color(0xFFFF6B3D)).withOpacity(0.6),
            shadowColor: const Color(0xFFFF6B3D).withOpacity(0.4),
          ),
          child: isLoading
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      textColor ?? Colors.white,
                    ),
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color: textColor ?? Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      );
    }
  }
}