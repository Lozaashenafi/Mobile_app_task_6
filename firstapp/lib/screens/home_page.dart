import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shoe_provider.dart';
import '../widgets/shoe_card.dart'; // Assuming ShoeCard is implemented correctly for the list item design
import 'detail_page.dart';
import 'add_edit_page.dart';
import 'search_page.dart'; // Import the SearchPage for navigation

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Helper method to build the custom header content
  Widget _buildCustomHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Avatar, Date/Name, Notification Icon
          Row(
            children: [
              // Avatar Square
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                // You can add an image/icon here
              ),
              const SizedBox(width: 15),

              // Date + Hello Text
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'July 14, 2023',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const Text(
                    'Hello, Yohannes',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Notification Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.notifications_none,
                  color: Colors.grey[700],
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // Row 2: "Available Products" Title + Search Icon
          Row(
            children: [
              const Text(
                "Available Products",
                style: TextStyle(
                  fontSize: 26, // Larger and bolder than before
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              // Search Icon Button
              InkWell(
                onTap: () {
                  // Navigate to the Search Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.search, size: 24, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10), // Small spacer before the list starts
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shoeProvider = Provider.of<ShoeProvider>(context);
    final shoes = shoeProvider.shoes;

    return Scaffold(
      backgroundColor: Colors.white,
      // Removed the standard AppBar to match the image's full-bleed header layout
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Header (replaces AppBar and initial title/search padding)
          _buildCustomHeader(context),

          // Vertical list of cards
          Expanded(
            child:
                shoes.isEmpty
                    ? const Center(child: Text("No shoes available. Add some!"))
                    : ListView.builder(
                      // Adjusted horizontal padding to match the general padding of the page
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: shoes.length,
                      itemBuilder:
                          (ctx, i) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: 24,
                            ), // Increased bottom spacing
                            child: ShoeCard(
                              shoe: shoes[i],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => DetailPage(shoeId: shoes[i].id),
                                  ),
                                );
                              },
                            ),
                          ),
                    ),
          ),
        ],
      ),

      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3F51B5), // Deep blue color
        shape: const CircleBorder(), // Ensures perfect circle
        elevation: 8,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditPage()),
          );
        },
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
    );
  }
}
