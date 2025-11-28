import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shoe.dart';
import '../providers/shoe_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

class AddEditPage extends StatefulWidget {
  final Shoe? shoe;
  const AddEditPage({this.shoe, super.key});

  @override
  State<AddEditPage> createState() => _AddEditPageState();
}

class _AddEditPageState extends State<AddEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late String name;
  late String category;
  late double size;
  late double price;
  late String description;
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    // ... initialization code remains the same ...
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

  void saveShoe() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newShoe = Shoe(
        id: widget.shoe?.id ?? _uuid.v4(),
        name: name,
        category: category,
        // Ensure size and price are handled correctly even if input is empty
        size: size,
        price: price,
        description: description,
        imageUrl: imageUrl,
      );

      final provider = Provider.of<ShoeProvider>(context, listen: false);
      if (widget.shoe != null) {
        provider.updateShoe(widget.shoe!.id, newShoe);
      } else {
        provider.addShoe(newShoe);
      }
      Navigator.pop(context);
    }
  }

  // Helper method for clean input field styling
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      fillColor: Colors.grey.shade100,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shoe != null ? 'Edit Shoe' : 'Add New Shoe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: name,
                decoration: _inputDecoration('Name'),
                validator: (val) => val!.isEmpty ? 'Enter name' : null,
                onSaved: (val) => name = val!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: category,
                decoration: _inputDecoration('Category'),
                validator: (val) => val!.isEmpty ? 'Enter category' : null,
                onSaved: (val) => category = val!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: size == 0 ? '' : size.toString(),
                decoration: _inputDecoration('Size (e.g., 42.0)'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Enter size' : null,
                onSaved: (val) => size = double.tryParse(val!) ?? 0.0,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: price == 0 ? '' : price.toString(),
                decoration: _inputDecoration('Price (e.g., 99.99)'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Enter price' : null,
                onSaved: (val) => price = double.tryParse(val!) ?? 0.0,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: description,
                decoration: _inputDecoration('Description'),
                maxLines: 3,
                validator: (val) => val!.isEmpty ? 'Enter description' : null,
                onSaved: (val) => description = val!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: imageUrl,
                decoration: _inputDecoration('Image URL'),
                validator: (val) => val!.isEmpty ? 'Enter image URL' : null,
                onSaved: (val) => imageUrl = val!,
              ),
              const SizedBox(height: 30),
              // ElevatedButton uses the theme style defined in main.dart
              ElevatedButton(
                onPressed: saveShoe,
                child: Text(widget.shoe != null ? 'Update Shoe' : 'Add Shoe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
