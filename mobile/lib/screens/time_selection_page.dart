import 'package:coffeeapp/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:coffeeapp/models/coffee_selection.dart';
import 'package:coffeeapp/services/api.dart';
import 'package:coffeeapp/services/style.dart'; // Импортируем файл стилей
import 'package:intl/intl.dart'; // Для форматирования времени
import 'package:vibration/vibration.dart'; // Импортируем плагин вибрации

class TimeSelectionPage extends StatefulWidget {
  final CoffeeSelection coffeeSelection;
  final List<String> sweets;
  final String selectedCoffeeShop; // Принимаем выбранную кофейню

  const TimeSelectionPage({
    super.key,
    required this.coffeeSelection,
    required this.sweets,
    required this.selectedCoffeeShop,
  });

  @override
  State<TimeSelectionPage> createState() => _TimeSelectionPageState();
}

class _TimeSelectionPageState extends State<TimeSelectionPage> {
  int _selectedHour = 9; // Стандартный час
  int _selectedMinute = 30; // Стандартные минуты
  final FixedExtentScrollController _hourController = FixedExtentScrollController(initialItem: 9);
  final FixedExtentScrollController _minuteController = FixedExtentScrollController(initialItem: 6);
  final int _minHour = 8;
  final int _maxHour = 18;

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }

  void _scheduleReminder() {
    final selectedTimeOfDay = TimeOfDay(hour: _selectedHour, minute: _selectedMinute);
    CoffeeShopService().addScheduledOrder(
      coffeeSelection: widget.coffeeSelection,
      sweets: widget.sweets,
      coffeeShopName: widget.selectedCoffeeShop,
      reminderTime: selectedTimeOfDay,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: accentColor,
        title: Text('Напоминание создано!', style: headlineSmall),
        content: Text(
          'Ваш заказ будет готов к ${(_selectedHour).toString().padLeft(2, '0')}:${(_selectedMinute).toString().padLeft(2, '0')}',
          style: bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (Route<dynamic> route) => false,
              );
            },
            child: Text('Готово', style: bodyLarge.copyWith(color: primaryColor, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final coffeeDetails = '${widget.coffeeSelection.quantity} ${widget.coffeeSelection.coffeeType}'
        '${widget.coffeeSelection.milk ? " с молоком" : ""}'
        '${widget.coffeeSelection.sugar ? " с сахаром" : ""}';
    final sweetsText = widget.sweets.isNotEmpty ? widget.sweets.join(', ') : 'не выбрали';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        title: Text('Выберите время', style: headlineSmall),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: bodyLarge.copyWith(fontStyle: FontStyle.italic, color: textColor, fontWeight: FontWeight.w600),
                    children: [
                      const TextSpan(text: 'Ваш заказ в '),
                      TextSpan(
                        text: widget.selectedCoffeeShop,
                        style: bodyLarge.copyWith(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, color: primaryColor),
                      ),
                      const TextSpan(text: ', все верно?'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '- $coffeeDetails',
                  style: bodyMedium,
                ),
                Text(
                  '- Десерты: $sweetsText',
                  style: bodyMedium,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Text(
            'Выберите время заказа',
            style: headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hours selector
                SizedBox(
                  width: 70,
                  child: ListWheelScrollView.useDelegate(
                    controller: _hourController,
                    itemExtent: 50,
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        if (index >= _minHour && index <= _maxHour) {
                          _selectedHour = index;
                          Vibration.vibrate(duration: 5);
                        } else if (index < _minHour) {
                          _hourController.animateToItem(_minHour, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          _selectedHour = _minHour;
                        } else {
                          _hourController.animateToItem(_maxHour, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                          _selectedHour = _maxHour;
                        }
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 24,
                      builder: (context, index) {
                        return Center(
                          child: Text(
                            index.toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: index == _selectedHour ? FontWeight.bold : FontWeight.normal,
                              color: index >= _minHour && index <= _maxHour ? textColor : secondaryTextColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Text(
                  ':',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                ),
                // Minutes selector
                SizedBox(
                  width: 70,
                  child: ListWheelScrollView.useDelegate(
                    controller: _minuteController,
                    itemExtent: 50,
                    perspective: 0.005,
                    diameterRatio: 1.2,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _selectedMinute = index * 5;
                        Vibration.vibrate(duration: 5);
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      childCount: 12, // 0, 5, 10, ..., 55
                      builder: (context, index) {
                        final minute = index * 5;
                        return Center(
                          child: Text(
                            minute.toString().padLeft(2, '0'),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: minute == _selectedMinute ? FontWeight.bold : FontWeight.normal,
                              color: textColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedHour >= _minHour && _selectedHour <= _maxHour) {
                    _scheduleReminder();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Пожалуйста, выберите время с ${_minHour}:00 до ${_maxHour}:00', style: bodyMedium)),
                    );
                  }
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
                  'НАПОМНИТЬ МНЕ',
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
}