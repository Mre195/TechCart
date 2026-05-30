import 'package:flutter/material.dart';

ValueNotifier<bool> isDarkMode = ValueNotifier(false);

void toggleTheme() {
  isDarkMode.value = !isDarkMode.value;
}