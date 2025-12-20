import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback? onTap;
  final bool selected;

  const CategoryChip({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        avatar: Text(icon, style: const TextStyle(fontSize: 20)),
        label: Text(label),
        selected: selected,
        onSelected: onTap != null ? (_) => onTap!() : null,
        showCheckmark: false,
      ),
    );
  }
}
