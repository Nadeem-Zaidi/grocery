import 'package:flutter/material.dart';

class FormCheckbox extends StatefulWidget {
  final String? label;
  final ValueChanged<bool>? onChanged;
  final bool initialValue;

  const FormCheckbox({
    super.key,
    this.label,
    this.onChanged,
    this.initialValue = false,
  });

  @override
  State<FormCheckbox> createState() => _FormCheckboxState();
}

class _FormCheckboxState extends State<FormCheckbox> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  Color _getCheckboxColor(Set<WidgetState> states) {
    final theme = Theme.of(context);

    if (states.contains(WidgetState.selected)) {
      return theme.colorScheme.primary;
    }
    if (states.contains(WidgetState.hovered)) {
      return theme.colorScheme.primary.withOpacity(0.5);
    }
    if (states.contains(WidgetState.pressed)) {
      return theme.colorScheme.primary.withOpacity(0.6);
    }
    return theme.colorScheme.outline;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
        widget.onChanged?.call(isChecked);
      },
      borderRadius: BorderRadius.circular(4),
      hoverColor: theme.colorScheme.primary.withOpacity(0.05),
      splashColor: theme.colorScheme.primary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Checkbox with proper hover effects
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value ?? false;
                });
                widget.onChanged?.call(isChecked);
              },
              fillColor: WidgetStateProperty.resolveWith(_getCheckboxColor),
              checkColor: theme.colorScheme.onPrimary,
              side: BorderSide(
                color: theme.colorScheme.outline,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),

            if (widget.label != null) ...[
              const SizedBox(width: 12),
              Text(
                widget.label!,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
