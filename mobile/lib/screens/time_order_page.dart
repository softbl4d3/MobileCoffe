import 'package:coffeeapp/services/api.dart';
import 'package:flutter/material.dart';
import 'package:coffeeapp/widgets/coffee_shop_card.dart';
import 'package:coffeeapp/screens/coffee_shop_page.dart';
import 'package:coffeeapp/models/coffe_shop_model.dart';
import 'package:coffeeapp/services/style.dart'; // Импортируем файл стилей

class TimeOrderPage extends StatefulWidget {
  const TimeOrderPage({super.key});

  @override
  State<TimeOrderPage> createState() => _TimeOrderPageState();
}

class _TimeOrderPageState extends State<TimeOrderPage> {
  late Future<List<CoffeeShop>> _coffeeShopsFuture;

  @override
  void initState() {
    super.initState();
    _coffeeShopsFuture = CoffeeShopService().fetchCoffeeShops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        title: Text('Заказать на время', style: headlineSmall),
        iconTheme: const IconThemeData(color: textColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Выберите кофейню',
              style: headlineMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<CoffeeShop>>(
                future: _coffeeShopsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: primaryColor));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Ошибка: ${snapshot.error}', style: bodyMedium.copyWith(color: Colors.red)));
                  } else if (snapshot.hasData) {
                    final coffeeShops = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      itemCount: coffeeShops.length,
                      itemBuilder: (context, index) {
                        final shop = coffeeShops[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Hero(
                            tag: 'coffee_shop_$index',
                            child: Material(
                              color: Colors.transparent,
                              child: CoffeeShopCard(
                                name: shop.name,
                                address: shop.address,
                                distance: shop.distance,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CoffeeShopPage(
                                        shopIndex: index,
                                        shopName: shop.name,
                                        isScheduledOrder: true,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('Нет данных о кофейнях', style: bodyMedium));
                  }
                },
              ),
            ),
          ],
        ),
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
}