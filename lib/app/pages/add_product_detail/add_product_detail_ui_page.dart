import 'dart:convert';

import 'package:acnoo_flutter_admin_panel/app/pages/api_service/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:file_picker/file_picker.dart';

import 'add_product_detail_controller.dart'; // Import for web image selection

class AddProductDetailUiPage extends StatefulWidget {
  const AddProductDetailUiPage({super.key});

  @override
  State<AddProductDetailUiPage> createState() => _AddProductDetailUiPageState();
}

class _AddProductDetailUiPageState extends State<AddProductDetailUiPage> {
  final List<Uint8List> _selectedImages = []; // Works for both mobile & web
  ProductDetailController productDetailController =
      Get.put(ProductDetailController());

  @override
  void initState() {
    super.initState();
    _fetchJewelryCategories();
  }

  Future<void> _pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true, // Allow multiple selection
    );

    if (result != null) {
      setState(() {
        _selectedImages.addAll(
            result.files.map((file) => file.bytes!).toList()); // Add new images
      });
    }
  }

  Future<void> _fetchJewelryCategories() async {
    try {
      List<Map<String, dynamic>> categories =
          await ApiService.fetchJewellaryCategoryImages();
      setState(() {
        productDetailController.categories = categories;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching jewelry categories: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth < 600 ? 16.0 : 32.0),
      child: Form(
        key: productDetailController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Select a Category",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              value: productDetailController.selectedCategory,
              isExpanded: true,
              items: productDetailController.categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category['item_title'],
                  child: Text(category['item_title']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  productDetailController.selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: productDetailController.itemNameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                suffixIcon: Icon(IconlyLight.edit, size: 20),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a product name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: productDetailController.itemPriceController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                labelText: 'Price',
                suffixIcon: Icon(IconlyLight.wallet, size: 20),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a price';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: productDetailController.itemDescController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Product Description',
                suffixIcon: Icon(IconlyLight.document, size: 20),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: productDetailController.itemSpecificationController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Product Specification',
                suffixIcon: Icon(IconlyLight.document, size: 20),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a specification';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.upload_file),
              label: const Text("Select Images"),
            ),
            _selectedImages.isNotEmpty
                ? Wrap(
                    spacing: 8,
                    children: _selectedImages.map((image) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Image.memory(image, width: 100, height: 100),
                          Positioned(
                            right: -10,
                            top: -10,
                            child: IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _selectedImages.remove(image);
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  )
                : const SizedBox(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (productDetailController.formKey.currentState?.validate() ??
                    false) {
                  final itemTitle = productDetailController.selectedCategory;
                  final itemName =
                      productDetailController.itemNameController.text;
                  final itemPrice =
                      productDetailController.itemPriceController.text;
                  final itemDesc =
                      productDetailController.itemDescController.text;

                  // Parse the itemSpecification input into a key-value map
                  final itemSpecificationInput =
                      productDetailController.itemSpecificationController.text;
                  final itemSpecificationMap =
                      _parseSpecification(itemSpecificationInput);

                  // Convert the map into a JSON string
                  final itemSpecificationJson =
                      json.encode(itemSpecificationMap);

                  try {
                    final success = await ApiService.addProductDetail(
                      context,
                      itemTitle!,
                      itemName,
                      itemPrice,
                      itemDesc,
                      itemSpecificationJson, // Send JSON formatted specification
                      _selectedImages,
                    );

                    if (success) {
                      if (kDebugMode) {
                        print("Product added successfully!");
                      }
                      productDetailController
                          .clearFormFields(); // Clear fields after success
                      setState(() {
                        _selectedImages.clear(); // Clear images list as well
                        productDetailController.selectedCategory =
                            null; // Update the UI to reset the dropdown
                      });
                    } else {
                      if (kDebugMode) {
                        print("Failed to add product");
                      }
                    }
                  } catch (e) {
                    if (kDebugMode) {
                      print("Error adding product: $e");
                    }
                  }
                }
              },
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }

  Map<String, String> _parseSpecification(String input) {
    final Map<String, String> parsedMap = {};

    // Split the input string by commas
    final entries = input.split(',');

    for (var entry in entries) {
      // Split each entry by the colon
      final parts = entry.split(':');
      if (parts.length == 2) {
        final key = parts[0].trim();
        final value = parts[1].trim();
        parsedMap[key] = value;
      }
    }

    return parsedMap;
  }
}
