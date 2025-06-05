import 'package:coffeeapp/services/api.dart';
import 'package:flutter/material.dart';
import 'package:coffeeapp/widgets/coffee_shop_card.dart';
import 'package:coffeeapp/screens/time_order_page.dart';
import 'package:coffeeapp/screens/coffee_shop_page.dart';
import 'package:coffeeapp/models/coffe_shop_model.dart';
import 'package:coffeeapp/services/style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Мой кофе', style: headlineLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: textColor,
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Text('Насладитесь моментом', style: headlineMedium.copyWith(fontWeight: FontWeight.normal)),
              ),

              // Regular Order Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Material(
                  elevation: 1,
                  borderRadius: BorderRadius.circular(12),
                  color: accentColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Может, как обычно?', style: headlineSmall),
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  style: bodyMedium,
                                  children: <TextSpan>[
                                    const TextSpan(text: 'Выберите ваш любимый\nнапиток и мы '),
                                    TextSpan(
                                      text: 'напомним',
                                      style: bodyMedium.copyWith(fontWeight: FontWeight.bold, color: primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        _StyledButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    const TimeOrderPage(),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  const begin = Offset(1.0, 0.0);
                                  const end = Offset.zero;
                                  const curve = Curves.easeInOut;
                                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          text: 'Давай',
                          icon: Icons.timer_outlined,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Coffee Shops List Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Text('Кофейни рядом с вами', style: headlineMedium),
              ),

              // Coffee Shops List
              FutureBuilder<List<CoffeeShop>>(
                future: _coffeeShopsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: primaryColor));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Ошибка: ${snapshot.error}', style: bodyMedium.copyWith(color: Colors.red)));
                  } else if (snapshot.hasData) {
                    final coffeeShops = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      itemCount: coffeeShops.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: CoffeeShopCard(
                            name: coffeeShops[index].name,
                            address: coffeeShops[index].address,
                            distance: coffeeShops[index].distance,
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => CoffeeShopPage(
                                    shopIndex: index,
                                    shopName: coffeeShops[index].name,
                                    isScheduledOrder: false,
                                  ),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    const begin = Offset(1.0, 0.0); // Справа налево
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;
                                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('Нет данных о кофейнях'));
                  }
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
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

// Кастомная стилизованная кнопка
class _StyledButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;

  const _StyledButton({
    required this.onPressed,
    required this.text,
    this.icon,
  });

  @override
  State<_StyledButton> createState() => _StyledButtonState();
}

class _StyledButtonState extends State<_StyledButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: _isPressed ? 0.95 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: accentColor, size: 20),
                const SizedBox(width: 6),
              ],
              Text(widget.text, style: buttonText),
            ],
          ),
        ),
      ),
    );
  }
}