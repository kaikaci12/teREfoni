import 'package:flutter/material.dart';

import 'package:frontend/utils/device/device_utils.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = TDeviceUtils.getScreenType(constraints.maxWidth);
        double bannerHeight = screenType == "desktop" ? 600 : 180;

        return Column(
          children: [
            Container(
              height: bannerHeight,
              decoration: BoxDecoration(
                color: Colors.grey[300], // Placeholder color
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  'Banner Placeholder',
                  style: TextStyle(
                    fontSize: screenType == "desktop" ? 24 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == 0
                        ? Colors.black
                        : Colors.grey, // First dot is active
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
