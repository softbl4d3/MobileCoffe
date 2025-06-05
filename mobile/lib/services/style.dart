import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Цветовая палитра
const Color primaryColor = Color(0xFF795548); // Более приглушенный кофейный
const Color accentColor = Color(0xFFEFEBE9); // Светло-бежевый (почти белый)
const Color backgroundColor = Color(0xFFF5F5F5); // Светло-серый фон
const Color textColor = Color(0xFF212121); // Темно-серый текст
const Color secondaryTextColor = Color(0xFF757575); // Серый второстепенный текст
const Color hintTextColor = Color(0xFFBDBDBD); // Светло-серый текст подсказок
const Color successColor = Color(0xFF4CAF50); // Зеленый для успеха

// Шрифты
TextStyle headlineLarge = GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.bold, color: textColor);
TextStyle headlineMedium = GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w600, color: textColor);
TextStyle headlineSmall = GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500, color: textColor);
TextStyle bodyLarge = GoogleFonts.roboto(fontSize: 16, color: textColor);
TextStyle bodyMedium = GoogleFonts.roboto(fontSize: 14, color: secondaryTextColor);
TextStyle bodySmall = GoogleFonts.roboto(fontSize: 12, color: secondaryTextColor);
TextStyle buttonText = GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500, color: accentColor);