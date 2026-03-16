import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final String icon;
  final String title;
  final String? value;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    this.value,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(isFirst ? 12 : 0),
        topRight: Radius.circular(isFirst ? 12 : 0),
        bottomLeft: Radius.circular(isLast ? 12 : 0),
        bottomRight: Radius.circular(isLast ? 12 : 0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 20,
              height: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            if (value != null) ...[
              Text(
                value!,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
