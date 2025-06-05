import 'package:flutter/material.dart';
import 'package:coffeeapp/screens/sweets_selection_page.dart';
import 'package:coffeeapp/models/coffee_selection.dart';
import 'package:coffeeapp/services/style.dart'; // Импортируем файл стилей

class CoffeeShopPage extends StatelessWidget {
  final int shopIndex;
  final String shopName;
  final bool isScheduledOrder;

  const CoffeeShopPage({
    super.key,
    required this.shopIndex,
    required this.shopName,
    this.isScheduledOrder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        title: Text(shopName, style: headlineSmall),
        iconTheme: const IconThemeData(color: textColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Чего желаете?',
              style: headlineMedium,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: 7,
              itemBuilder: (context, index) {
                if (index == 6) {
                  return _buildCoffeeItem(
                    context,
                    'Только сладкое',
                    null, // Иконку убираем
                    'assets/icons/cake_outlined.png', // Используем иконку как изображение
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SweetsSelectionPage(
                            coffeeSelection: CoffeeSelection(coffeeType: 'Default', quantity: 1, sugar: false, milk: false),
                            isScheduledOrder: isScheduledOrder,
                            shopName: shopName,
                          ),
                        ),
                      );
                    },
                    price: null,
                  );
                }

                final coffeeTypes = [
                  {'name': 'Эспрессо', 'image': 'lib/media/coffee_images/Espresso.jpg', 'price': '150 ₽'},
                  {'name': 'Капучино', 'image': 'lib/media/coffee_images/Cappuccino.jpg', 'price': '220 ₽'},
                  {'name': 'Латте', 'image': 'lib/media/coffee_images/Latte.jpg', 'price': '250 ₽'},
                  {'name': 'Американо', 'image': 'lib/media/coffee_images/Americano.jpg', 'price': '180 ₽'},
                  {'name': 'Мокко', 'image': 'lib/media/coffee_images/Mocha.jpg', 'price': '270 ₽'},
                  {'name': 'Раф', 'image': 'lib/media/coffee_images/Raf.jpg', 'price': '290 ₽'},
                ];

                return _buildCoffeeItem(
                  context,
                  coffeeTypes[index]['name'] as String,
                  null, // Иконку убираем
                  coffeeTypes[index]['image'] as String,
                  () {
                    _showCoffeeOptionsBottomSheet(context, coffeeTypes[index]['name'] as String);
                  },
                  price: coffeeTypes[index]['price'] as String,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: accentColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: secondaryTextColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.coffee_outlined), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), label: 'История'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Профиль'),
        ],
      ),
    );
  }

  Widget _buildCoffeeItem(
    BuildContext context,
    String name,
    IconData? icon, // IconData теперь может быть null
    String? imagePath, // Путь к изображению
    VoidCallback onTap, {
    String? price,
  }) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Растягиваем содержимое по ширине
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imagePath != null
                      ? Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image_outlined, size: 60, color: Colors.grey);
                          },
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            size: 60,
                            color: primaryColor,
                          ),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: headlineSmall.copyWith(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (price != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      price,
                      style: bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showCoffeeOptionsBottomSheet(BuildContext context, String coffeeType) {
    int quantity = 1;
    bool sugar = false;
    bool milk = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: backgroundColor,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Чтобы bottom sheet занимал меньше места
                children: [
                  Text(
                    'Настройте ваш напиток',
                    style: headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Количество:', style: bodyLarge),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (quantity > 1) setState(() => quantity--);
                            },
                            icon: const Icon(Icons.remove_circle_outline, color: primaryColor),
                          ),
                          Text('$quantity', style: bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                          IconButton(
                            onPressed: () => setState(() => quantity++),
                            icon: const Icon(Icons.add_circle_outline, color: primaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Сахар:', style: bodyLarge),
                      Switch(
                        value: sugar,
                        onChanged: (value) => setState(() => sugar = value),
                        activeColor: primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Молоко:', style: bodyLarge),
                      Switch(
                        value: milk,
                        onChanged: (value) => setState(() => milk = value),
                        activeColor: primaryColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final coffeeSelection = CoffeeSelection(
                          coffeeType: coffeeType,
                          quantity: quantity,
                          sugar: sugar,
                          milk: milk,
                        );
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SweetsSelectionPage(
                              coffeeSelection: coffeeSelection,
                              isScheduledOrder: isScheduledOrder,
                              shopName: shopName,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('ПРОДОЛЖИТЬ', style: buttonText),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}