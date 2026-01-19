import 'package:flutter/material.dart';

import '../models/life_model.dart';
import '../widgets/ttl_text.dart';

class DaysView extends StatelessWidget {
  const DaysView({super.key, required this.lifeModel});

  final LifeModel lifeModel;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final Color secondaryText = Theme.of(context).colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TTLText(
            lifeModel.remainingDays.toString(),
            style: textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TTLText(
            'days remaining',
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
            color: secondaryText,
          ),
          const SizedBox(height: 24),
          TTLText(
            'What will you do today?',
            style: textTheme.bodyLarge,
            textAlign: TextAlign.center,
            color: secondaryText,
          ),
        ],
      ),
    );
  }
}
