import 'package:flutter_test/flutter_test.dart';
import 'package:firstapp/features/product/data/models/product_model.dart';
import 'package:firstapp/features/product/domain/entities/product.dart';

void main() {
  const tProductModel = ProductModel(
    id: '1',
    name: 'Test Shoe',
    description: 'Test Description',
    imageUrl: 'test.jpg',
    price: 99.99,
    size: 42.0,
    category: 'Test Category',
    rating: 4.5,
  );

  test('should be a subclass of Product entity', () async {
    expect(tProductModel, isA<Product>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON is provided', () async {
      // arrange
      final Map<String, dynamic> jsonMap = {
        "id": "1",
        "name": "Test Shoe",
        "description": "Test Description",
        "imageUrl": "test.jpg",
        "price": 99.99,
        "size": 42.0,
        "category": "Test Category",
        "rating": 4.5,
      };
      // act
      final result = ProductModel.fromJson(jsonMap);
      // assert
      expect(result, tProductModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      // act
      final result = tProductModel.toJson();
      // assert
      final expectedMap = {
        "id": "1",
        "name": "Test Shoe",
        "description": "Test Description",
        "imageUrl": "test.jpg",
        "price": 99.99,
        "size": 42.0,
        "category": "Test Category",
        "rating": 4.5,
      };
      expect(result, expectedMap);
    });
  });
}
