import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool enabled;
  final bool isAppointment;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    required this.isAppointment,
  });

  @override
  Widget build(BuildContext context) {
    final bool canPress = enabled && !isLoading;

    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: canPress ? onPressed : null,
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: isAppointment
              ? const Color(0xFF0000FF)
              : const Color(0xFF16A34A),
          disabledForegroundColor: Colors.grey.shade400,
          side: BorderSide(
            color: enabled
                ? isAppointment
                      ? const Color(0xFF0000FF)
                      : const Color(0xFF16A34A)
                : Colors.grey.shade300,
            width: 1.4,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: isLoading
              ? SizedBox(
                  key: const ValueKey('loading'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    color: const Color(0xFF16A34A),
                  ),
                )
              : Row(
                  key: const ValueKey('content'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 14),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
