import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shoe_provider.dart';
import '../widgets/shoe_card.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = ''; // Mock initial query to match the image
  String selectedCategory = ''; // State for the filter
  RangeValues priceRange = const RangeValues(
    0,
    500,
  ); // State for the filter price slider
  double minPrice = 0;
  double maxPrice = 500;

  @override
  void initState() {
    super.initState();
    // Initialize price range based on actual data if available, or sensible defaults
  }

  // --- 1. FILTER UI (Bottom Sheet/Modal) ---
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows content to take up more screen space
      builder: (BuildContext context) {
        // Use a StatefulWidget inside the modal to manage local filter state before applying
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 24,
                right: 24,
                // Adjust padding based on the keyboard
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Category Input (Placeholder for image matching)
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Select category...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                    ),
                    readOnly:
                        true, // Typically a dropdown or dialog would handle selection
                    onTap: () {
                      // Logic to open category selector
                    },
                  ),
                  const SizedBox(height: 20),

                  // Price Slider
                  const Text(
                    'Price',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Display current range (e.g., $100 - $400)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '\$${priceRange.start.round()} - \$${priceRange.end.round()}',
                      style: const TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  ),
                  RangeSlider(
                    values: priceRange,
                    min: minPrice,
                    max: maxPrice,
                    divisions: 100,
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

                  // APPLY Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                          0xFF3F51B5,
                        ), // Deep blue color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'APPLY',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- 2. SEARCH BAR WIDGET (Matching Image Look) ---
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Row(
        children: [
          // Text Input Field (White background, no borders)
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  controller: TextEditingController(
                    text: query,
                  ), // Set initial value 'Leather'
                  decoration: InputDecoration(
                    hintText: 'Search Product...',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: InputBorder.none,
                    // Use suffix icon as the arrow in the image
                    suffixIcon: const Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF3F51B5), // Deep blue
                    ),
                  ),
                  onChanged: (val) => setState(() => query = val),
                  onSubmitted: (val) {
                    // Trigger search/filter here
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Filter Button (Blue background, rounded)
          SizedBox(
            width: 50,
            height: 50,
            child: ElevatedButton(
              onPressed: _showFilterSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F51B5), // Deep blue color
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

  // --- 3. MAIN BUILD METHOD ---
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ShoeProvider>(context);
    // Note: In a real app, searchShoes would take priceRange and selectedCategory as filters
    final results = provider.searchShoes(query);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Custom AppBar to match the image: Back button + 'Search Product' title
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
        children: [
          _buildSearchBar(),
          Expanded(
            child:
                results.isEmpty && query.isNotEmpty
                    ? Center(
                      child: Text(
                        'No results found for "$query"',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                    : results.isEmpty && query.isEmpty
                    ? const Center(
                      child: Text(
                        'Start typing to search available products.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      // Changed from GridView.builder to ListView.builder
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 10,
                      ),
                      itemCount: results.length,
                      itemBuilder:
                          (ctx, i) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: 24,
                            ), // Spacing between cards
                            child: ShoeCard(
                              // Assuming ShoeCard is still used for the item layout
                              shoe: results[i],
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              DetailPage(shoeId: results[i].id),
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
