import 'package:flutter/material.dart';

class RecentHistory extends StatelessWidget {
  final List<String> recentMeals;

  const RecentHistory({
    super.key,
    required this.recentMeals,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent History',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.black),
        ),
        const SizedBox(height: 16),
        Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.builder(
            itemCount: recentMeals.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  recentMeals[index],
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.black),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
