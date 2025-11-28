import 'package:flutter/material.dart';
import '../models/shoe.dart';

class ShoeProvider with ChangeNotifier {
  final List<Shoe> _shoes = [
    Shoe(
      id: '1',
      name: 'Running Shoe',
      description: 'Comfortable running shoe for daily workouts',
      category: 'Sports',
      size: 42,
      price: 79.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/Air_Jordan_1_Banned.jpg/1200px-Air_Jordan_1_Banned.jpg',
    ),
    Shoe(
      id: '2',
      name: 'Casual Sneaker',
      description: 'Stylish sneaker for everyday wear',
      category: 'Casual',
      size: 40,
      price: 99.99,
      imageUrl:
          'https://redtape.com/cdn/shop/files/RSL1073_1._bcd54810-97be-4448-ab60-5c07412084c9.jpg?v=1756809100',
    ),
  ];

  // Return a copy of the list
  List<Shoe> get shoes => [..._shoes];

  // Find shoe by ID
  Shoe findById(String id) {
    return _shoes.firstWhere((shoe) => shoe.id == id);
  }

  // Add a new shoe
  void addShoe(Shoe shoe) {
    _shoes.add(shoe);
    notifyListeners();
  }

  // Update an existing shoe
  void updateShoe(String id, Shoe newShoe) {
    final index = _shoes.indexWhere((shoe) => shoe.id == id);
    if (index >= 0) {
      _shoes[index] = newShoe;
      notifyListeners();
    }
  }

  // Delete a shoe
  void deleteShoe(String id) {
    _shoes.removeWhere((shoe) => shoe.id == id);
    notifyListeners();
  }

  // Search shoes by name
  List<Shoe> searchShoes(String query) {
    return _shoes
        .where((shoe) => shoe.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
