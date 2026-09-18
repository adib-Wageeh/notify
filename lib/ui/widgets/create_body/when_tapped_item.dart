import 'package:flutter/material.dart';
import 'package:notify/core/app_colors.dart';
import 'package:notify/core/app_constants.dart';

class WhenTappedItem extends StatelessWidget {
  const WhenTappedItem({super.key, required this.whenTapped});

  final ValueNotifier<String> whenTapped;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "When tapped",
          style: TextStyle(
            color: AppColors.grey300,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        ValueListenableBuilder<String>(
          valueListenable: whenTapped,
          builder: (context, value, _) {
            return DropdownButton<String>(
              value: value,
              style: TextStyle(
                color: AppColors.grey300,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
              dropdownColor: AppColors.primary700,
              items: AppConstants.whatToOpenItems.keys
                  .map(
                    (item) => DropdownMenuItem<String>(
                      value: item,
                      onTap: () => whenTapped.value = item,
                      child: Text(
                        item,
                        style: TextStyle(
                          color: AppColors.grey300,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (item) {},
            );
          },
        ),
      ],
    );
  }
}


