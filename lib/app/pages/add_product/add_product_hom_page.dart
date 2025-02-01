import 'dart:convert';

import 'package:acnoo_flutter_admin_panel/app/pages/api_service/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:file_picker/file_picker.dart';

import '../add_product_detail/add_product_detail_controller.dart';
import 'add_product_controller.dart';

class AddProductHomPage extends StatefulWidget {
  const AddProductHomPage({super.key});

  @override
  State<AddProductHomPage> createState() => _AddProductHomPageState();
}

class _AddProductHomPageState extends State<AddProductHomPage> {
  final List<Uint8List> _selectedImages = []; // Works for both mobile & web
  ProductHomePageController productHomePageController =
      Get.put(ProductHomePageController());

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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth < 600 ? 16.0 : 32.0),
      child: Form(
        key: productHomePageController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: productHomePageController.nameController,
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
            const SizedBox(height: 20),
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
                if (productHomePageController.formKey.currentState?.validate() ??
                    false) {
                  final itemName = productHomePageController.nameController.text;

                  // Parse the itemSpecification input into a key-value map

                  try {
                    final success = await ApiService.addHomePage(
                      context,
                      itemName,
                      _selectedImages,
                    );

                    if (success) {
                      if (kDebugMode) {
                        print("Product added successfully!");
                      }
                      productHomePageController
                          .clearFormFields(); // Clear fields after success
                      setState(() {
                        _selectedImages.clear(); // Clear images list as well
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

}
