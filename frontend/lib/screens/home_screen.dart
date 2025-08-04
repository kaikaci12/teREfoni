// Helper function to determine the screen type
import 'package:flutter/material.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/utils/device/device_utils.dart';
import 'package:frontend/widgets/app_bar_actions.dart';
import 'package:frontend/widgets/banner.dart';
import 'package:frontend/widgets/bottom_navigation.dart';
import 'package:frontend/widgets/category_card.dart';
import 'package:frontend/widgets/product_card.dart';
import 'package:frontend/widgets/search_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: LayoutBuilder(
          builder: (context, constraints) {
            final screenType = TDeviceUtils.getScreenType(constraints.maxWidth);
            if (screenType == "desktop") {
              return Row(
                children: [
                  Text(
                    t.appTitle,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 50),
                  Expanded(child: const SearchField()),
                ],
              );
            }
            return const SearchField();
          },
        ),
        actions: const [AppBarActions()],
      ),
      bottomNavigationBar: const BottomNavigationWidget(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenType = TDeviceUtils.getScreenType(constraints.maxWidth);
          // Adjust padding and layout based on screen type
          final double horizontalPadding = screenType == "desktop" ? 120 : 16;
          final int crossAxisCount = screenType == "mobile"
              ? 2
              : (screenType == "tablet" ? 3 : 4);

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const BannerWidget(),
                  const SizedBox(height: 24),
                  Text(
                    t.categories,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  // Responsive categories: row on desktop, wrap on mobile
                  const CategoriesWidget(),
                  const SizedBox(height: 24),
                  Text(
                    t.categories,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  // Responsive product grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8, // Adjust as needed
                    ),
                    itemCount: 8, // Example: display 8 products
                    itemBuilder: (context, index) {
                      // Example product data
                      return ProductCard(
                        imagePath:
                            "/assets/products/product_placeholder.jpg", // Placeholder image
                        name: 'iPhone 14',
                        color: 'Midnight',
                        storage: '128 GB',
                        price: '1 500',
                        oldPrice: '2 500',
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
