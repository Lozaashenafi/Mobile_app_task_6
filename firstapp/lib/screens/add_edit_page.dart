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
        size: size,
        price: price,
        description: description,
        imageUrl: imageUrl,
        rating: 4.1,
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
            'Add Product',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Container(
                  height: 130,
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 40,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'upload image',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // Name Field
                Text(
                  'name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black45,
                  ),
                ),
                SizedBox(height: 4),
                TextFormField(
                  initialValue: name,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF3F3F3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter name' : null,
                  onSaved: (val) => name = val!,
                ),
                SizedBox(height: 10),

                // Category Field
                Text(
                  'category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: category,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter category' : null,
                  onSaved: (val) => category = val!,
                ),
                SizedBox(height: 10),

                // Price Field
                Text(
                  'price',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 4),
                TextFormField(
                  initialValue: price == 0 ? '' : price.toString(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val) => val!.isEmpty ? 'Enter price' : null,
                  onSaved: (val) => price = double.tryParse(val!) ?? 0.0,
                ),
                SizedBox(height: 10),

                // Description Field
                Text(
                  'description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 4),
                TextFormField(
                  initialValue: description,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                  ),
                  maxLines: 4,
                  validator: (val) => val!.isEmpty ? 'Enter description' : null,
                  onSaved: (val) => description = val!,
                ),
                SizedBox(height: 10),
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
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'ADD',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (widget.shoe != null) {
                          final provider = Provider.of<ShoeProvider>(
                            context,
                            listen: false,
                          );
                          provider.deleteShoe(widget.shoe!.id);
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Colors.red, // border color
                            width: 1, // border thickness
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'DELETE',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
