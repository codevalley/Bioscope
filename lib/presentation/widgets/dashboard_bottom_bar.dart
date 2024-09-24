import 'package:flutter/material.dart';

class DashboardBottomBar extends StatelessWidget {
  final VoidCallback onAddMealPressed;
  final VoidCallback onAnalyticsPressed;
  final VoidCallback onSettingsPressed;

  const DashboardBottomBar({
    Key? key,
    required this.onAddMealPressed,
    required this.onAnalyticsPressed,
    required this.onSettingsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: onAnalyticsPressed,
          ),
          FloatingActionButton(
            onPressed: onAddMealPressed,
            child: const Icon(Icons.add),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: onSettingsPressed,
          ),
        ],
      ),
    );
  }
}
