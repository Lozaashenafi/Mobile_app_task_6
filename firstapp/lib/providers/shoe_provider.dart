import 'package:flutter/material.dart';
import '../models/shoe.dart';

class ShoeProvider with ChangeNotifier {
  final List<Shoe> _shoes = [
    Shoe(
      id: '1',
      name: 'Running Shoe',
      description:
          'A derby leather shoe is a classic and versatile footwear option characterized by its open lacing system, where the shoelace eyelets are sewn on top of the vamp (the upper part of the shoe). This design feature provides a more relaxed and casual look compared to the closed lacing system of oxford shoes. Derby shoes are typically made of high-quality leather, known for its durability and elegance, making them suitable for both formal and casual occasions. With their timeless style and comfortable fit, derby leather shoes are a staple in any well-rounded wardrobe.',
      category: 'Sports',
      size: 42,
      price: 79.99,
      imageUrl: '../../assets/images/shoe.jpg',
      rating: 4.1,
    ),
    Shoe(
      id: '2',
      name: 'Casual Sneaker',
      description: 'Stylish sneaker for everyday wear',
      category: 'Casual',
      size: 40,
      price: 99.99,
      imageUrl: '../../assets/images/shoe.jpg',
      rating: 4.1,
    ),
    Shoe(
      id: '2',
      name: 'Casual Sneaker',
      description: 'Stylish sneaker for everyday wear',
      category: 'Casual',
      size: 40,
      price: 99.99,
      rating: 4.1,
      imageUrl: '../../assets/images/shoe.jpg',
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
