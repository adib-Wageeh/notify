import 'package:flutter/material.dart';
import 'package:notify/core/app_colors.dart';
import 'package:notify/core/app_constants.dart';

class DeliveryTypeItem extends StatelessWidget {
  const DeliveryTypeItem({
    super.key,
    required this.selectedItem,
    required this.selectedUserKey,
  });

  final ValueNotifier<String> selectedItem;
  final ValueNotifier<String> selectedUserKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Delivery",
          style: TextStyle(
            color: AppColors.grey300,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<String>(
          valueListenable: selectedItem,
          builder: (context, value, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  runSpacing: 8,
                  spacing: 8,
                  children: AppConstants.deliveryType
                      .map(
                        (item) => Material(
                          color: value == item
                              ? AppColors.primary700
                              : AppColors.grey700,
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            onTap: () {
                              if (value != item) {
                                selectedItem.value = item;
                              }
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 12,
                              ),
                              child: Text(
                                item,
                                style: TextStyle(
                                  color: AppColors.grey100,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                if (value == "Cloud test") ...[
                  const SizedBox(height: 8),
                  ValueListenableBuilder<String>(
                    valueListenable: selectedUserKey,
                    builder: (context, value, _) {
                      return DropdownButton<String>(
                        value: value,
                        style: TextStyle(
                          color: AppColors.grey300,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                        dropdownColor: AppColors.primary700,
                        items: AppConstants.usersTokens.keys
                            .map(
                              (item) => DropdownMenuItem<String>(
                                value: item,
                                onTap: () => selectedUserKey.value = item,
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
              ],
            );
          },
        ),
      ],
    );
  }
}
