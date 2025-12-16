import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../domain/entities/product.dart';
import '../providers/product_provider.dart';

class AddEditPage extends StatefulWidget {
  final Product? product;
  const AddEditPage({this.product, super.key});

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

  File? _selectedImage;
  Uint8List? _webImage;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      name = widget.product!.name;
      category = widget.product!.category;
      size = widget.product!.size;
      price = widget.product!.price;
      description = widget.product!.description;
      imageUrl = widget.product!.imageUrl;
    } else {
      name = '';
      category = '';
      size = 0;
      price = 0;
      description = '';
      imageUrl = '';
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImage = bytes;
            imageUrl = 'data:image/png;base64,${base64.encode(bytes)}';
          });
        } else {
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

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    if (widget.product == null && imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final product = Product(
      id: widget.product?.id ?? _uuid.v4(),
      name: name,
      category: category,
      size: size,
      price: price,
      description: description,
      imageUrl: imageUrl,
      rating: widget.product?.rating ?? 4.1,
    );

    final provider = Provider.of<ProductProvider>(context, listen: false);

    if (widget.product != null) {
      await provider.editProduct(product);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      await provider.addProduct(product);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }

    Navigator.pop(context);
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
            widget.product != null ? 'Edit Product' : 'Add Product',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Product Image',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: _buildImagePreview(),
                  ),
                ),
                const SizedBox(height: 20),

                _buildField(
                  label: 'Product Name',
                  initialValue: name,
                  onSaved: (v) => name = v,
                ),
                _buildField(
                  label: 'Category',
                  initialValue: category,
                  onSaved: (v) => category = v,
                ),
                _buildField(
                  label: 'Size',
                  initialValue: size == 0 ? '' : size.toString(),
                  keyboardType: TextInputType.number,
                  onSaved: (v) => size = double.tryParse(v) ?? 0,
                ),
                _buildField(
                  label: 'Price (\$)',
                  initialValue: price == 0 ? '' : price.toString(),
                  keyboardType: TextInputType.number,
                  onSaved: (v) => price = double.tryParse(v) ?? 0,
                ),
                _buildField(
                  label: 'Description',
                  initialValue: description,
                  maxLines: 4,
                  onSaved: (v) => description = v,
                ),

                const SizedBox(height: 30),

                ElevatedButton(
                  onPressed: _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3F51B5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    widget.product != null ? 'UPDATE' : 'ADD',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                if (widget.product != null) ...[
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () async {
                      final provider = Provider.of<ProductProvider>(
                        context,
                        listen: false,
                      );
                      await provider.removeProduct(widget.product!.id);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'DELETE',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String initialValue,
    required Function(String) onSaved,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
          onSaved: (v) => onSaved(v!),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF3F3F3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    if (kIsWeb && _webImage != null) {
      return Image.memory(_webImage!, fit: BoxFit.cover);
    }
    if (!kIsWeb && _selectedImage != null) {
      return Image.file(_selectedImage!, fit: BoxFit.cover);
    }
    if (widget.product != null && widget.product!.imageUrl.isNotEmpty) {
      return Image.network(widget.product!.imageUrl, fit: BoxFit.cover);
    }
    return const Center(child: Icon(Icons.add_photo_alternate_outlined));
  }
}
