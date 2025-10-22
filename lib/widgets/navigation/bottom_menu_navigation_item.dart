import 'package:flutter/material.dart';

class BottomMenuNavigationItem extends BottomNavigationBarItem {
  const BottomMenuNavigationItem({
    super.key,
    required super.icon,
    required super.label,
    required this.materialRoute,
  });
  final String materialRoute;
}
