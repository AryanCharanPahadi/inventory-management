import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconly/iconly.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart'; // Import for kIsWeb
import 'package:file_picker/file_picker.dart'; // Add for web support

import 'add_product_controller.dart';

class AddProductForm extends StatefulWidget {
  const AddProductForm({super.key});

  @override
  State<AddProductForm> createState() => _AddProductFormState();
}

class _AddProductFormState extends State<AddProductForm> {
  ProductController productController = Get.put(ProductController());
  final List<String> categories = ['Gurugram', 'Delhi', 'Noida', 'Saket'];
  String? selectedCategory;
  final _formKey = GlobalKey<FormState>();

  List<XFile>? _pickedImages = []; // For mobile images
  List<PlatformFile>? _webImages = []; // For web images

  // Pick images for both Web and Mobile
  Future<void> _pickImage() async {
    if (kIsWeb) {
      // Web image picking logic (multiple images)
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, // Only allow image files
        allowMultiple: true, // Enable multiple selection
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          // Append the selected files to the existing list
          _webImages = (_webImages ?? []) + result.files.cast<PlatformFile>();
        });
        print('Number of images selected (Web): ${_webImages!.length}');
      }
    } else {
      // Mobile image picking logic (multiple images)
      final ImagePicker picker = ImagePicker();
      final List<XFile>? images = await picker.pickMultiImage(); // Use pickMultiImage
      if (images != null && images.isNotEmpty) {
        setState(() {
          // Append the newly selected images to the existing list
          _pickedImages = (_pickedImages ?? []) + images;
        });
        print('Number of images selected (Mobile): ${_pickedImages!.length}');
      }
    }
  }

  // Show server response in an AlertDialog
  void showServerResponse(String title, String message, {bool isSuccess = false}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          title: Row(
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess ? Colors.green : Colors.red,
                size: 28,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isSuccess ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Icon(
                isSuccess ? Icons.thumb_up : Icons.warning_amber_outlined,
                size: 48,
                color: isSuccess ? Colors.green.withOpacity(0.7) : Colors.red.withOpacity(0.7),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: isSuccess ? Colors.green : Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                isSuccess ? 'Okay' : 'Try Again',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }


  // Method to display selected images
  Widget buildSelectedImages() {
    List<dynamic>? selectedImages = kIsWeb ? _webImages : _pickedImages;

    return selectedImages != null && selectedImages.isNotEmpty
        ? Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: List.generate(selectedImages.length, (index) {
        var image = selectedImages[index];
        return Stack(
          clipBehavior: Clip.none, // Ensure the icon stays on top of the image
          children: [
            GestureDetector(
              onTap: () {}, // Add any specific functionality here
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.5)),
                ),
                child: kIsWeb && image is PlatformFile
                    ? Image.memory(image.bytes!, fit: BoxFit.cover)
                    : !kIsWeb && image is XFile
                    ? Image.file(File(image.path), fit: BoxFit.cover)
                    : SizedBox(),
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: () {
                  // Add logic to remove the image from the list
                  setState(() {
                    selectedImages.removeAt(index);
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    )
        : Center(child: Text('No images selected'));
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth < 600 ? 16.0 : 32.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue;
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
                  return 'Please select a category';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Select Godown',
                suffixIcon: const Icon(IconlyLight.category, size: 20),
              ),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: productController.nameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                suffixIcon: const Icon(IconlyLight.edit, size: 20),
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
              controller: productController.quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                // Allows numbers with optional 2 decimal places
              ],
              decoration: InputDecoration(
                labelText: 'Quantity',
                suffixIcon: const Icon(IconlyLight.plus, size: 20),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a quantity';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: productController.priceController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                // Allows numbers with optional 2 decimal places
              ],              decoration: InputDecoration(
                labelText: 'Price',
                suffixIcon: const Icon(IconlyLight.wallet, size: 20),
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
              controller: productController.descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                suffixIcon: const Icon(IconlyLight.document, size: 20),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Images'),
            ),
            const SizedBox(height: 16),

            buildSelectedImages(),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  final productName = productController.nameController.text;
                  final quantity = int.tryParse(productController.quantityController.text) ?? 0;
                  final price = double.tryParse(productController.priceController.text) ?? 0.0;
                  final description = productController.descriptionController.text;
                  final category = selectedCategory;

                  try {
                    await productController.addProduct(
                      productName: productName,
                      quantity: quantity,
                      price: price,
                      description: description,
                      category: category,
                    );

                    // Show server response in popup
                    if (productController.serverResponse != null) {
                      showServerResponse(
                        "Success",
                        productController.serverResponse!,
                        isSuccess: productController.isSuccess,
                      );
                    }

                    // Clear all input fields after successful product addition
                    productController.nameController.clear();
                    productController.quantityController.clear();
                    productController.priceController.clear();
                    productController.descriptionController.clear();
                    // Clear the selected category (dropdown)
                    setState(() {
                      selectedCategory = null; // Reset the selected category
                    });
                  } catch (e) {
                    showServerResponse("Error", "Something went wrong: $e");
                  }
                }
              },
              child: const Text('Add Product'),
            )

          ],
        ),
      ),
    );
  }
}
