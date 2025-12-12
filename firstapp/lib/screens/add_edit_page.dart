import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/shoe.dart';
import '../providers/shoe_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert'; // For base64 encoding

class AddEditPage extends StatefulWidget {
  final Shoe? shoe;
  const AddEditPage({this.shoe, super.key});

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();
  final ImagePicker _picker = ImagePicker();

  late String name;
  late String category;
  late double size;
  late double price;
  late String description;
  late String imageUrl;

  File? _selectedImage; // For mobile
  Uint8List? _webImage; // For web

  @override
  void initState() {
    super.initState();
    if (widget.shoe != null) {
      name = widget.shoe!.name;
      category = widget.shoe!.category;
      size = widget.shoe!.size;
      price = widget.shoe!.price;
      description = widget.shoe!.description;
      imageUrl = widget.shoe!.imageUrl;
    } else {
      name = '';
      category = '';
      size = 0;
      price = 0;
      description = '';
      imageUrl = '';
    }
  }

  // Function to pick image - works for both web and mobile
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          // For web: convert to bytes
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImage = bytes;
            // For web, we'll use a data URL or base64 string
            // In a real app, you'd upload this to a server
            imageUrl = 'data:image/png;base64,' + base64Encode(bytes);
          });
        } else {
          // For mobile: use File
          setState(() {
            _selectedImage = File(pickedFile.path);
            imageUrl = pickedFile.path;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void saveShoe() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Determine final image URL
      String finalImageUrl = imageUrl;

      // If it's a new product, we need some image
      if (widget.shoe == null && imageUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an image'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final newShoe = Shoe(
        id: widget.shoe?.id ?? _uuid.v4(),
        name: name,
        category: category,
        size: size,
        price: price,
        description: description,
        imageUrl: finalImageUrl,
        rating: 4.1,
      );

      final provider = Provider.of<ShoeProvider>(context, listen: false);
      if (widget.shoe != null) {
        provider.updateShoe(widget.shoe!.id, newShoe);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        provider.addShoe(newShoe);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      Navigator.pop(context);
    }
  }

  // Helper to encode bytes to base64 (you need to import 'dart:convert')
  String base64Encode(List<int> bytes) {
    return base64.encode(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          centerTitle: true,
          title: Text(
            widget.shoe != null ? 'Edit Product' : 'Add Product',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Image Upload Section
                const SizedBox(height: 10),
                const Text(
                  'Product Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Image container that's clickable
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: _buildImagePreview(),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Tap to select image from gallery',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 20),

                // Name Field
                const Text(
                  'Product Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF3F3F3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter name' : null,
                  onSaved: (val) => name = val!,
                ),
                const SizedBox(height: 16),

                // Category Field
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: category,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF3F3F3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter category' : null,
                  onSaved: (val) => category = val!,
                ),
                const SizedBox(height: 16),

                // Size Field
                const Text(
                  'Size',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: size == 0 ? '' : size.toString(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF3F3F3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val) => val!.isEmpty ? 'Enter size' : null,
                  onSaved: (val) => size = double.tryParse(val!) ?? 0.0,
                ),
                const SizedBox(height: 16),

                // Price Field
                const Text(
                  'Price (\$)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: price == 0 ? '' : price.toString(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF3F3F3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    prefixText: '\$ ',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val) {
                    if (val!.isEmpty) return 'Enter price';
                    final parsed = double.tryParse(val);
                    if (parsed == null || parsed <= 0) {
                      return 'Enter valid price';
                    }
                    return null;
                  },
                  onSaved: (val) => price = double.tryParse(val!) ?? 0.0,
                ),
                const SizedBox(height: 16),

                // Description Field
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: description,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF3F3F3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  maxLines: 4,
                  validator: (val) => val!.isEmpty ? 'Enter description' : null,
                  onSaved: (val) => description = val!,
                ),
                const SizedBox(height: 30),

                // Buttons Row
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: saveShoe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3F51B5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        widget.shoe != null ? 'UPDATE' : 'ADD',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (widget.shoe != null)
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                  'Are you sure you want to delete this product?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final provider =
                                          Provider.of<ShoeProvider>(
                                            context,
                                            listen: false,
                                          );
                                      provider.deleteShoe(widget.shoe!.id);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Product deleted successfully!',
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.red, width: 1),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'DELETE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    // Show selected image if exists
    if (kIsWeb && _webImage != null) {
      // For web: show from bytes
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.memory(
          _webImage!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } else if (!kIsWeb && _selectedImage != null) {
      // For mobile: show from file
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          _selectedImage!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } else if (widget.shoe != null && widget.shoe!.imageUrl.isNotEmpty) {
      // Show existing image if editing
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          widget.shoe!.imageUrl,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildUploadPlaceholder();
          },
        ),
      );
    } else {
      // Show placeholder if no image
      return _buildUploadPlaceholder();
    }
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: 40,
          color: Colors.grey.shade600,
        ),
        const SizedBox(height: 8),
        Text(
          'Add Image',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
      ],
    );
  }
}
