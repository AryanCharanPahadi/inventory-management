import 'dart:convert';

import 'package:acnoo_flutter_admin_panel/app/pages/api_service/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:file_picker/file_picker.dart';

import 'add_banner_controller.dart';

class AddBanner extends StatefulWidget {
  const AddBanner({super.key});

  @override
  State<AddBanner> createState() => _AddBannerState();
}

class _AddBannerState extends State<AddBanner> {
  final List<Uint8List> _selectedImages = []; // Works for both mobile & web
  AddBannerController addBannerController = Get.put(AddBannerController());

  @override
  void initState() {
    super.initState();
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

  final List<String> categories = ['Jewellery Banner'];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth < 600 ? 16.0 : 32.0),
      child: Form(
        key: addBannerController.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: addBannerController.selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  addBannerController.selectedCategory = newValue;
                });
              },
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select this field';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Select Product Category',
                suffixIcon: Icon(IconlyLight.category, size: 20),
              ),
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
                if (addBannerController.formKey.currentState?.validate() ??
                    false) {
                  final itemTitle = addBannerController.selectedCategory;

                  try {
                    final success = await ApiService.addBanner(
                      context,
                      itemTitle!,
                      _selectedImages,
                    );

                    if (success) {
                      if (kDebugMode) {
                        print("Product added successfully!");
                      }
                      addBannerController
                          .clearFormFields(); // Clear fields after success
                      setState(() {
                        _selectedImages.clear(); // Clear images list as well
                        addBannerController.selectedCategory =
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
