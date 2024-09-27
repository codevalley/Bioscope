import 'package:flutter/material.dart';

class DashboardBottomBar extends StatelessWidget {
  final VoidCallback onAddMealPressed;
  final VoidCallback onHomePressed;
  final VoidCallback onEditGoalsPressed;

  const DashboardBottomBar({
    Key? key,
    required this.onAddMealPressed,
    required this.onHomePressed,
    required this.onEditGoalsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFFFBFAF8),
        border: Border(top: BorderSide(color: Colors.black, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBottomBarItem(
            icon: Icons.home,
            color: const Color(0xFFED764A),
            onPressed: onHomePressed,
          ),
          _buildAddMealButton(),
          _buildBottomBarItem(
            icon: Icons.edit,
            color: const Color(0xFFA1A1A1),
            onPressed: onEditGoalsPressed,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBarItem({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, color: color),
      onPressed: onPressed,
      iconSize: 30,
    );
  }

  Widget _buildAddMealButton() {
    return GestureDetector(
      onTap: onAddMealPressed,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFED764A),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
