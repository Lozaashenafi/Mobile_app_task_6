import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shoe_provider.dart';
import 'add_edit_page.dart';

class DetailPage extends StatelessWidget {
  final String shoeId;
  const DetailPage({required this.shoeId, super.key});

  @override
  Widget build(BuildContext context) {
    final shoeProvider = Provider.of<ShoeProvider>(context, listen: true);
    // Find the shoe using the ID
    final shoe = shoeProvider.findById(shoeId);

    final List<double> availableSizes = [39, 40, 41, 42, 43, 44];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 1. TOP SECTION: Image and Back Button
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(
                    0xFFF3E5D8,
                  ), // Light beige background from image
                  image: DecorationImage(
                    image: NetworkImage(shoe.imageUrl),
                    fit:
                        BoxFit
                            .fill, // Contain ensures the whole shoe is visible
                  ),
                ),
              ),
              Positioned(
                top: 50,
                left: 20,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // 2. SCROLLABLE CONTENT SECTION
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        shoe.category, // e.g. "Men's shoe"
                        style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            "(4.0)",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Name and Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          shoe.name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        '\$${shoe.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Dark grey/black per image
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // Size Label
                  const Text(
                    "Size:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Size Selector Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          availableSizes.map((s) {
                            // Check if this size matches the shoe's size
                            bool isSelected = s == shoe.size;
                            return Container(
                              margin: const EdgeInsets.only(right: 12),
                              width: 50,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? const Color(0xFF3F51B5)
                                        : Colors.white, // Blue if selected
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                s.toStringAsFixed(0),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Description
                  Text(
                    shoe.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5, // Line height for readability
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. BOTTOM BUTTONS (Pinned to bottom)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                // DELETE BUTTON
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      shoeProvider.deleteShoe(shoeId);
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "DELETE",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // UPDATE BUTTON
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEditPage(shoe: shoe),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF3F51B5,
                      ), // Matches the blue in image
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "UPDATE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
