import 'package:flutter/material.dart';

import 'package:frontend/utils/device/device_utils.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // A list of categories to display
    final categories = ['Android', 'iPhone'];

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = TDeviceUtils.getScreenType(constraints.maxWidth);

        if (screenType == "mobile") {
          // Display a scrollable row of buttons for mobile
          return SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CategoryButton(
                    text: categories[index],
                    onPressed: () {},
                    isActive: index == 0,
                  ),
                );
              },
            ),
          );
        } else {
          // Digsplay a row of buttons for tablet/desktop
          return Row(
            children: categories.map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: CategoryButton(
                  text: category,
                  onPressed: () {},
                  isActive: category == 'Android',
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}

// CategoryButton remains the same
class CategoryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isActive;

  const CategoryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: isActive ? Colors.white : Colors.black,
        backgroundColor: isActive ? Colors.black : Colors.grey[200],
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
      child: Text(text),
    );
  }
}
