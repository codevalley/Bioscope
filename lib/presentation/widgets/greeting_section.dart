import 'package:flutter/material.dart';
import '../../utils/date_formatter.dart';

class GreetingSection extends StatelessWidget {
  final String greeting;
  final DateTime date;

  const GreetingSection({
    Key? key,
    required this.greeting,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          DateFormatter.formatGreetingDate(date),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}
