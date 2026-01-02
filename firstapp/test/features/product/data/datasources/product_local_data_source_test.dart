import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firstapp/core/error/exception.dart';
import 'package:firstapp/features/product/data/datasources/product_local_data_source_impl.dart';
import 'package:firstapp/features/product/data/models/product_model.dart';

// Generate Mocks
import 'product_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late ProductLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ProductLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  const tProductModel = ProductModel(
    id: '1',
    name: 'Test Shoe',
    description: 'Description',
    imageUrl: 'url',
    price: 100,
    size: 42,
    category: 'Category',
  );

  group('getLastProducts', () {
    test(
      'should return List<ProductModel> from SharedPreferences when there is data in the cache',
      () async {
        // arrange
        final jsonString = json.encode([tProductModel.toJson()]);
        when(mockSharedPreferences.getString(any)).thenReturn(jsonString);

        // act
        final result = await dataSource.getLastProducts();

        // assert
        verify(mockSharedPreferences.getString('CACHED_PRODUCTS'));
        expect(result, equals([tProductModel]));
      },
    );

    test(
      'should throw a CacheException when there is no cached value',
      () async {
        // arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);

        // act
        final call = dataSource.getLastProducts;

        // assert
        expect(() => call(), throwsA(isA<CacheException>()));
      },
    );
  });

  group('cacheProducts', () {
    test('should call SharedPreferences to store the data', () async {
      // arrange
      final expectedJsonString = json.encode([tProductModel.toJson()]);
      when(
        mockSharedPreferences.setString(any, any),
      ).thenAnswer((_) async => true);

      // act
      await dataSource.cacheProducts([tProductModel]);

      // assert
      verify(
        mockSharedPreferences.setString('CACHED_PRODUCTS', expectedJsonString),
      );
    });
  });
}
