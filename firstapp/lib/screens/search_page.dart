import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shoe.dart';
import '../providers/shoe_provider.dart';
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
  String selectedCategory = 'All'; // Default category
  RangeValues priceRange = const RangeValues(0, 500);
  double minPrice = 0;
  double maxPrice = 500;

  // Available categories
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

    // Initialize price range based on actual shoe data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ShoeProvider>();
      final shoes = provider.shoes;
      if (shoes.isNotEmpty) {
        // Find min and max prices from the actual data
        double min = shoes.first.price;
        double max = shoes.first.price;
        for (var shoe in shoes) {
          if (shoe.price < min) min = shoe.price;
          if (shoe.price > max) max = shoe.price;
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

  // Function to show category selection dialog
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

  // Function to apply filters and search
  List<Shoe> _getFilteredShoes(ShoeProvider provider) {
    List<Shoe> filteredShoes = provider.searchShoes(query);

    // Apply category filter
    if (selectedCategory != 'All') {
      filteredShoes =
          filteredShoes
              .where((shoe) => shoe.category == selectedCategory)
              .toList();
    }

    // Apply price range filter
    filteredShoes =
        filteredShoes
            .where(
              (shoe) =>
                  shoe.price >= priceRange.start &&
                  shoe.price <= priceRange.end,
            )
            .toList();

    return filteredShoes;
  }

  // --- FILTER UI (Bottom Sheet/Modal) ---
  void _showFilterSheet() {
    // Store current values to allow cancellation
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
                  // Header with Clear All button
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

                  // Category Selection
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

                  // Price Range Filter
                  const Text(
                    'Price Range',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Display current price range
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${priceRange.start.round()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${priceRange.end.round()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                  const SizedBox(height: 10),
                  // Price range indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${minPrice.round()}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        '\$${maxPrice.round()}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Action Buttons
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              // Reset to original values
                              setState(() {
                                selectedCategory = originalCategory;
                                priceRange = originalPriceRange;
                              });
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'CANCEL',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Apply Button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Apply filters and close modal
                              setState(() {});
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3F51B5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'APPLY',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- SEARCH BAR WIDGET ---
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search Product...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (val) {
                          setState(() {
                            query = val;
                          });
                        },
                        onSubmitted: (val) {
                          setState(() {
                            query = val;
                          });
                        },
                      ),
                    ),
                    if (query.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          setState(() {
                            query = '';
                            _searchController.clear();
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Filter Button
          SizedBox(
            width: 50,
            height: 50,
            child: ElevatedButton(
              onPressed: _showFilterSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F51B5),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Icon(Icons.tune, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  // --- Active Filters Display ---
  Widget _buildActiveFilters() {
    final hasActiveFilters =
        selectedCategory != 'All' ||
        priceRange.start != minPrice ||
        priceRange.end != maxPrice;

    if (!hasActiveFilters) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active Filters:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              if (selectedCategory != 'All')
                Chip(
                  label: Text('Category: $selectedCategory'),
                  onDeleted: () {
                    setState(() {
                      selectedCategory = 'All';
                    });
                  },
                ),
              if (priceRange.start != minPrice || priceRange.end != maxPrice)
                Chip(
                  label: Text(
                    'Price: \$${priceRange.start.round()} - \$${priceRange.end.round()}',
                  ),
                  onDeleted: () {
                    setState(() {
                      priceRange = RangeValues(minPrice, maxPrice);
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShoeProvider>(context);
    final filteredShoes = _getFilteredShoes(provider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Search Product',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          _buildActiveFilters(),
          Expanded(
            child:
                filteredShoes.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off,
                            size: 60,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            query.isEmpty
                                ? 'Start typing to search available products.'
                                : 'No results found for "$query"',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          if (selectedCategory != 'All' ||
                              priceRange.start != minPrice ||
                              priceRange.end != maxPrice)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                'Try adjusting your filters',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 10,
                      ),
                      itemCount: filteredShoes.length,
                      itemBuilder:
                          (ctx, i) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ShoeCard(
                              shoe: filteredShoes[i],
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => DetailPage(
                                            shoeId: filteredShoes[i].id,
                                          ),
                                    ),
                                  ),
                            ),
                          ),
                    ),
          ),
        ],
      ),
    );
  }
}
