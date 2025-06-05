import 'package:flutter/material.dart';
import 'package:coffeeapp/screens/order_summary_page.dart';
import 'package:coffeeapp/models/coffee_selection.dart';
import 'package:coffeeapp/screens/time_selection_page.dart';
import 'package:coffeeapp/services/style.dart'; // Импортируем файл стилей

class SweetsSelectionPage extends StatefulWidget {
  final CoffeeSelection coffeeSelection;
  final bool isScheduledOrder;
  final String shopName;

  const SweetsSelectionPage({
    super.key,
    required this.coffeeSelection,
    this.isScheduledOrder = false,
    required this.shopName,
  });

  @override
  State<SweetsSelectionPage> createState() => _SweetsSelectionPageState();
}

class _SweetsSelectionPageState extends State<SweetsSelectionPage> {
  List<String> _selectedSweets = [];

  void _toggleSweet(String sweetName) {
    setState(() {
      if (_selectedSweets.contains(sweetName)) {
        _selectedSweets.remove(sweetName);
      } else {
        _selectedSweets.add(sweetName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        title: Text('Сладкое к кофе', style: headlineSmall),
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
              'Выберите десерт',
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
                final sweetTypes = [
                  {'name': 'Круассан', 'image': 'lib/media/desserts/croissant.jpg', 'price': '180 ₽'},
                  {'name': 'Маффин', 'image': 'lib/media/desserts/muffin.jpg', 'price': '150 ₽'},
                  {'name': 'Чизкейк', 'image': 'lib/media/desserts/cheese_cake.jpg', 'price': '320 ₽'},
                  {'name': 'Эклер', 'image': 'lib/media/desserts/eclair.jpg', 'price': '220 ₽'},
                  {'name': 'Печенье', 'image': 'lib/media/desserts/cookie.jpg', 'price': '120 ₽'},
                  {'name': 'Донат', 'image': 'lib/media/desserts/donut.jpg', 'price': '180 ₽'},
                  {'name': 'Откажусь', 'icon': Icons.not_interested_outlined, 'color': Colors.grey.shade300, 'price': null},
                ];
                final sweet = sweetTypes[index];
                final isSelected = _selectedSweets.contains(sweet['name']);

                return _buildSweetItem(
                  context: context,
                  name: sweet['name'] as String,
                  imagePath: sweet['image'] as String?,
                  icon: sweet['icon'] as IconData?,
                  isSelected: isSelected,
                  onTap: () {
                    if (sweet['name'] == 'Откажусь') {
                      setState(() {
                        _selectedSweets = [];
                      });
                    } else {
                      _toggleSweet(sweet['name'] as String);
                    }
                  },
                  price: sweet['price'] as String?,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedSweets.isNotEmpty || widget.isScheduledOrder
                    ? () {
                        if (widget.isScheduledOrder) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TimeSelectionPage(
                                coffeeSelection: widget.coffeeSelection,
                                sweets: _selectedSweets,
                                selectedCoffeeShop: widget.shopName,
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderSummaryPage(
                                coffeeSelection: widget.coffeeSelection,
                                sweets: _selectedSweets,
                              ),
                            ),
                          );
                        }
                      }
                    : null, // Disable button if no sweets selected and not a scheduled order
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: primaryColor.withOpacity(0.5),
                  disabledForegroundColor: accentColor.withOpacity(0.5),
                ),
                child: Text(
                  widget.isScheduledOrder ? 'ВЫБРАТЬ ВРЕМЯ' : 'ПРОДОЛЖИТЬ',
                  style: buttonText,
                ),
              ),
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

  Widget _buildSweetItem({
    required BuildContext context,
    required String name,
    String? imagePath,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            size: 40,
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
}