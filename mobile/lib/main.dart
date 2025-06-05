import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coffeeapp/app.dart'; // Импортируем наш CoffeeApp

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const CoffeeApp());
}