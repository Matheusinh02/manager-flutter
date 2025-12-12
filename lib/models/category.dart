import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  // Categorias pré-definidas
  static const List<Category> defaultCategories = [
    Category(
      id: 'work',
      name: 'Trabalho',
      icon: Icons.work,
      color: Colors.blue,
    ),
    Category(
      id: 'personal',
      name: 'Pessoal',
      icon: Icons.person,
      color: Colors.green,
    ),
    Category(
      id: 'shopping',
      name: 'Compras',
      icon: Icons.shopping_cart,
      color: Colors.orange,
    ),
    Category(
      id: 'health',
      name: 'Saúde',
      icon: Icons.health_and_safety,
      color: Colors.red,
    ),
    Category(
      id: 'study',
      name: 'Estudos',
      icon: Icons.school,
      color: Colors.purple,
    ),
    Category(
      id: 'finance',
      name: 'Finanças',
      icon: Icons.attach_money,
      color: Colors.teal,
    ),
    Category(
      id: 'home',
      name: 'Casa',
      icon: Icons.home,
      color: Colors.brown,
    ),
    Category(
      id: 'other',
      name: 'Outros',
      icon: Icons.category,
      color: Colors.grey,
    ),
  ];

  static Category? findById(String id) {
    try {
      return defaultCategories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
