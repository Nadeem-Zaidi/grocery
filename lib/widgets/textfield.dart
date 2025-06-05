import 'package:flutter/material.dart';

Widget buildTextField(
  BuildContext context, {
  TextEditingController? controller,
  required String label,
  required String hint,
  IconData? icon,
  bool isSelectable = false,
  int maxLines = 1,
  int? maxLength,
  VoidCallback? onTap,
  ValueChanged<String>? onChanged, // Added onChanged callback
  Widget? suffixIcon,
  TextInputType? keyboardType,
  bool obscureText = false,
  String? Function(String?)? validator, // Added validation support
  FocusNode? focusNode,
  EdgeInsetsGeometry? contentPadding,
  InputBorder? focusedBorder,
  InputBorder? errorBorder,
  String? errorText,
}) {
  final theme = Theme.of(context);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.8),
        ),
      ),
      const SizedBox(height: 4),
      GestureDetector(
        onTap: isSelectable ? onTap : null,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null && errorText != ""
                  ? theme.colorScheme.error
                  : theme.colorScheme.outline.withOpacity(0.3),
            ),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            maxLength: maxLength,
            readOnly: isSelectable,
            obscureText: obscureText,
            keyboardType: keyboardType,
            focusNode: focusNode,
            validator: validator,
            onChanged: onChanged, // Added onChanged parameter
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: contentPadding ??
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
              prefixIcon: icon != null
                  ? Icon(icon, color: theme.colorScheme.primary)
                  : null,
              suffixIcon: suffixIcon,
              counterText: '', // Remove default counter text
              focusedBorder: focusedBorder,
              errorBorder: errorBorder,
            ),
          ),
        ),
      ),
      if (errorText != null || errorText != "")
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            errorText ?? "",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ),
    ],
  );
}
