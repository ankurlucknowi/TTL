import 'package:flutter/material.dart';

import '../models/life_model.dart';
import '../widgets/ttl_text.dart';

class ProgressView extends StatelessWidget {
  const ProgressView({super.key, required this.lifeModel});

  final LifeModel lifeModel;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color secondaryText = Theme.of(context).colorScheme.onSurfaceVariant;
    final Color trackColor = Theme.of(context).dividerColor;
    final Color fillColor = Theme.of(context).colorScheme.primary;
    final int percent = (lifeModel.progress * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TTLText(
            'Life Progress',
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: lifeModel.progress,
              minHeight: 8,
              backgroundColor: trackColor,
              valueColor: AlwaysStoppedAnimation<Color>(fillColor),
            ),
          ),
          const SizedBox(height: 16),
          TTLText(
            "You’ve lived $percent% of the life you imagined.",
            style: textTheme.bodyLarge,
            color: secondaryText,
          ),
        ],
      ),
    );
  }
}
