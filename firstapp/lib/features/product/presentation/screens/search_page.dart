import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/product.dart';
import '../providers/product_provider.dart';
import '../widgets/shoe_card.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  String query = '';
  String selectedCategory = 'All';
  RangeValues priceRange = const RangeValues(0, 500);
  double minPrice = 0;
  double maxPrice = 500;

  final List<String> categories = [
    'All',
    'Running',
    'Casual',
    'Basketball',
    'Sneakers',
    'Formal',
    'Sandals',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: 'Leather');
    query = 'Leather';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductProvider>();
      final products = provider.products;

      if (products.isNotEmpty) {
        double min = products.first.price;
        double max = products.first.price;

        for (var product in products) {
          if (product.price < min) min = product.price;
          if (product.price > max) max = product.price;
        }

        setState(() {
          minPrice = min;
          maxPrice = max;
          priceRange = RangeValues(min, max);
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCategoryDialog(BuildContext context, StateSetter setStateModal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Category'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(categories[index]),
                  trailing:
                      selectedCategory == categories[index]
                          ? const Icon(Icons.check, color: Colors.blue)
                          : null,
                  onTap: () {
                    setStateModal(() {
                      selectedCategory = categories[index];
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  List<Product> _getFilteredProducts(ProductProvider provider) {
    List<Product> filteredProducts =
        provider.products.where((product) {
          return product.name.toLowerCase().contains(query.toLowerCase());
        }).toList();

    if (selectedCategory != 'All') {
      filteredProducts =
          filteredProducts
              .where((product) => product.category == selectedCategory)
              .toList();
    }

    filteredProducts =
        filteredProducts
            .where(
              (product) =>
                  product.price >= priceRange.start &&
                  product.price <= priceRange.end,
            )
            .toList();

    return filteredProducts;
  }

  void _showFilterSheet() {
    final originalCategory = selectedCategory;
    final originalPriceRange = priceRange;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setStateModal(() {
                            selectedCategory = 'All';
                            priceRange = RangeValues(minPrice, maxPrice);
                          });
                        },
                        child: const Text(
                          'Clear All',
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => _showCategoryDialog(context, setStateModal),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedCategory,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Price Range',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${priceRange.start.round()}'),
                        Text('\$${priceRange.end.round()}'),
                      ],
                    ),
                  ),
                  RangeSlider(
                    values: priceRange,
                    min: minPrice,
                    max: maxPrice,
                    divisions: 50,
                    labels: RangeLabels(
                      '\$${priceRange.start.round()}',
                      '\$${priceRange.end.round()}',
                    ),
                    onChanged: (RangeValues newRange) {
                      setStateModal(() {
                        priceRange = newRange;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                selectedCategory = originalCategory;
                                priceRange = originalPriceRange;
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('CANCEL'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {});
                              Navigator.pop(context);
                            },
                            child: const Text('APPLY'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() {
                  query = val;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search Product...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(icon: const Icon(Icons.tune), onPressed: _showFilterSheet),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final filteredProducts = _getFilteredProducts(provider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Product'),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child:
                filteredProducts.isEmpty
                    ? const Center(child: Text('No products found'))
                    : ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder:
                          (ctx, i) => ProductCard(
                            product: filteredProducts[i],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => DetailPage(
                                        productId: filteredProducts[i].id,
                                      ),
                                ),
                              );
                            },
                          ),
                    ),
          ),
        ],
      ),
    );
  }
}
