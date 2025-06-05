import 'package:coffeeapp/models/coffe_shop_model.dart'; 
import 'package:coffeeapp/models/coffee_selection.dart';
import 'package:flutter/material.dart';
class CoffeeShopService {
  Future<List<CoffeeShop>> fetchCoffeeShops() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final List<CoffeeShop> fakeCoffeeShops = [
      CoffeeShop(
        name: 'Утро',
        address: 'ул. Пушкина, д. 10',
        distance: '500 м',
      ),
      CoffeeShop(
        name: 'Tucano',
        address: ' Ш. чел Маре, д. 25',
        distance: '1.2 км',
      ),
      CoffeeShop(
        name: 'Кофе с собой',
        address: 'ул. Миорица, д. 5',
        distance: '800 м',
      ),
      CoffeeShop(
        name: 'возле уника',
        address: 'бул. Дачия, д. 30/2',
        distance: '2.1 км',
      ),
      CoffeeShop(
        name: 'Кофейный дворик',
        address: 'ул. Иона Крянгэ, д. 15',
        distance: '650 м',
      ),
    ];
    return fakeCoffeeShops;
  }
    Future<void> addScheduledOrder({
    required CoffeeSelection coffeeSelection,
    required List<String> sweets,
    required String coffeeShopName,
    required TimeOfDay reminderTime,
  }) async {
    // Заглушка для отправки данных на бэкэнд
    print('Отправка данных на бэкэнд:');
    print('Кофейня: $coffeeShopName');
    print('Кофе: ${coffeeSelection.coffeeType} (${coffeeSelection.quantity} шт.)');
    print('Сладости: ${sweets.join(', ')}');


    // Здесь будет ваш реальный POST-запрос к бэкэнду
    // Например:
    // final response = await http.post(
    //   Uri.parse('YOUR_BACKEND_URL/schedule_order'),
    //   body: {
    //     'coffeeType': coffeeSelection.coffeeType,
    //     'quantity': coffeeSelection.quantity.toString(),
    //     'sweets': sweets.join(','),
    //     'coffeeShopName': coffeeShopName,
    //     'reminderTime': '${reminderTime.hour}:${reminderTime.minute}',
    //   },
    // );
    // if (response.statusCode == 200) {
    //   print('Заказ успешно запланирован');
    // } else {
    //   print('Ошибка при планировании заказа: ${response.statusCode}');
    // }

    // Для заглушки просто возвращаем Future.delayed
    await Future.delayed(const Duration(seconds: 1));
    print('Заглушка: Заказ на время успешно создан.');
  }

}

