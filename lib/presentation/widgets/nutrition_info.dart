import 'package:flutter/material.dart';
import 'package:bioscope/domain/entities/nutrition_info.dart';

class NutritionInfoWidget extends StatelessWidget {
  final NutritionInfo nutritionInfo;

  const NutritionInfoWidget({Key? key, required this.nutritionInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutrition Facts',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
          ),
          const Divider(color: Colors.black, thickness: 8),
          const SizedBox(height: 8),
          Text(
            nutritionInfo.summary,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.black, thickness: 1),
          ...nutritionInfo.nutrition.map((component) => Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          component.component,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Text(
                          '${component.value} ${component.unit}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.black, thickness: 1, height: 1),
                ],
              )),
        ],
      ),
    );
  }
}
