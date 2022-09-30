import 'package:flutter/material.dart';

class Food {
  final String image;
  final String name1;
  final String name2;
  final Color color;
  Food({
    required this.image,
    required this.name1,
    required this.name2,
    required this.color,
  });
}

List<Food> liste = [
  Food(
    image: 'assets/images/food2.png',
    name1: 'Gallo',
    name2: 'Pinto',
    color: const Color(0xFFF0F8FF),
  ),
  Food(
    image: 'assets/images/food1.png',
    name1: 'Bread',
    name2: 'Dumplings',
    color: const Color(0xFFFFF1D7),
  ),
  Food(
    image: 'assets/images/food3.png',
    name1: 'Dim',
    name2: 'Sum',
    color: const Color(0xFFF0FFF0),
  ),
  Food(
    image: 'assets/images/food4.png',
    name1: 'Masala',
    name2: 'Dosa',
    color: const Color(0xFFf5f5dc),
  ),
];
