import 'package:flutter/material.dart';
import 'package:coffeeapp/models/coffee_selection.dart';
import 'package:coffeeapp/services/style.dart'; // Импортируем файл стилей

class OrderSummaryPage extends StatelessWidget {
  final CoffeeSelection coffeeSelection;
  final List<String> sweets;
  final String? selectedCoffeeShop; // Может быть null, если заказ "как обычно"

  const OrderSummaryPage({
    super.key,
    required this.coffeeSelection,
    required this.sweets,
    this.selectedCoffeeShop,
  });

  @override
  Widget build(BuildContext context) {
    final coffeeDetails = '${coffeeSelection.coffeeType}, ${coffeeSelection.quantity} шт.'
        '${coffeeSelection.sugar ? ', Сахар' : ''}'
        '${coffeeSelection.milk ? ', Молоко' : ''}';

    final sweetsText = sweets.isNotEmpty ? sweets.join(', ') : 'Нет';
    final sweetsQuantity = sweets.isNotEmpty ? '${sweets.length} шт.' : '';
    final orderAmount = calculateOrderAmount(); // Заглушка для расчета суммы

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Ваш заказ', style: headlineSmall.copyWith(color: textColor)),
        backgroundColor: accentColor,
        iconTheme: const IconThemeData(color: textColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Обратный переход
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Проверьте детали',
              style: headlineMedium,
            ),
            const SizedBox(height: 16),
            // Блок с информацией о кофе
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.local_cafe_outlined, size: 32, color: primaryColor.withOpacity(0.8)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Кофе', style: headlineSmall.copyWith(fontWeight: FontWeight.w500)),
                        Text(coffeeDetails, style: bodyLarge.copyWith(color: textColor.withOpacity(0.8))),
                        Text('250 ₽', style: bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit_outlined, color: primaryColor.withOpacity(0.8)),
                    onPressed: () {
                      // TODO: Навигация обратно на выбор кофе
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Переход к выбору кофе')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Блок с информацией о десертах (если есть)
            if (sweets.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.cake_outlined, size: 32, color: primaryColor.withOpacity(0.8)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Десерты', style: headlineSmall.copyWith(fontWeight: FontWeight.w500)),
                          Text(sweetsText, style: bodyLarge.copyWith(color: textColor.withOpacity(0.8))),
                          if (sweetsQuantity.isNotEmpty)
                            Text('180 ₽', style: bodyLarge.copyWith(fontWeight: FontWeight.bold)), // Предполагаемая цена
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit_outlined, color: primaryColor.withOpacity(0.8)),
                      onPressed: () {
                        // TODO: Навигация обратно на выбор сладостей
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Переход к выбору сладостей')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            // Способ получения
            Text('Способ получения', style: headlineSmall.copyWith(fontWeight: FontWeight.w500)),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Самовывоз', style: bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                  Text('15-20 мин', style: bodyMedium.copyWith(color: textColor.withOpacity(0.6))),
                  TextButton(
                    onPressed: () {
                      // TODO: Переход на выбор способа получения
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Изменить')),
                      );
                    },
                    child: Text('Изменить', style: bodyLarge.copyWith(color: primaryColor)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Итого
            Text('Итого', style: headlineSmall.copyWith(fontWeight: FontWeight.w500)),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Сумма заказа', style: bodyLarge.copyWith(color: textColor.withOpacity(0.8))),
                      Text('${orderAmount} ₽', style: bodyLarge.copyWith(color: textColor.withOpacity(0.8))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Скидка', style: bodyLarge.copyWith(color: textColor.withOpacity(0.8))),
                      Text('0 ₽', style: bodyLarge.copyWith(color: textColor.withOpacity(0.8))),
                    ],
                  ),
                  const Divider(thickness: 1, color: Colors.grey),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('К оплате', style: headlineSmall.copyWith(fontWeight: FontWeight.bold)),
                      Text('${orderAmount} ₽', style: headlineSmall.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Способ оплаты (заглушка)
            Text('Способ оплаты', style: headlineSmall.copyWith(fontWeight: FontWeight.w500)),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.credit_card_outlined, color: primaryColor.withOpacity(0.8)),
                      ),
                      const SizedBox(width: 12),
                      Text('Оплата при получении', style: bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Переход на выбор способа оплаты
                      final snackBarStyle = bodyLarge.copyWith(color: primaryColor);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Изменить', style: snackBarStyle)),
                      );
                    },
                    child: Text('Изменить', style: bodyLarge.copyWith(color: primaryColor)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Тут будет логика оформления заказа
                  final snackBarStyle = bodyLarge.copyWith(color: accentColor);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Заказ оформлен!', style: snackBarStyle)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'ОФОРМИТЬ ЗАКАЗ',
                  style: bodyLarge.copyWith(fontWeight: FontWeight.bold, color: accentColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Заглушка для расчета суммы заказа
  double calculateOrderAmount() {
    double amount = 250.0; // Цена кофе
    if (sweets.isNotEmpty) {
      amount += sweets.length * 180.0; // Предполагаемая цена десерта
    }
    return amount;
  }
}