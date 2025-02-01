import 'dart:convert';

import 'package:acnoo_flutter_admin_panel/app/pages/api_service/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:file_picker/file_picker.dart';

import '../add_product_detail/add_product_detail_controller.dart';
import '../tables_page/jewellery_details_table.dart';

class EditProductDetailsUi extends StatefulWidget {
  final UserProductDetail? productDetail;

  const EditProductDetailsUi({
    super.key,
    this.productDetail,
  });

  @override
  State<EditProductDetailsUi> createState() => _EditProductDetailsUiState();
}

class _EditProductDetailsUiState extends State<EditProductDetailsUi> {
  ProductDetailController productDetailController =
      Get.put(ProductDetailController());
  final List<Uint8List> _selectedImages = [];
  final _formKey = GlobalKey<FormState>();
  String? selectedCategory;

  final itemNameController = TextEditingController();
  final itemSpecificationController = TextEditingController();
  final itemPriceController = TextEditingController();
  final itemDescController = TextEditingController();
  final itemTitleController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchJewelryCategories();

    if (widget.productDetail != null) {
      itemNameController.text = widget.productDetail!.name;
      itemPriceController.text = widget.productDetail!.price;
      itemDescController.text = widget.productDetail!.desc;

      // Set the selected category in the controller
      productDetailController.selectedCategory = widget.productDetail!.title;

      // Parse and format the size field
      if (widget.productDetail!.size != null) {
        try {
          // Parse the JSON string into a Map
          Map<String, dynamic> sizeMap =
              jsonDecode(widget.productDetail!.size!);

          // Convert the map into the desired format (key:value,key:value)
          String formattedSize = sizeMap.entries
              .map((entry) => '${entry.key}:${entry.value}')
              .join(',');

          // Set the formatted string to the controller
          itemSpecificationController.text = formattedSize;
        } catch (e) {
          if (kDebugMode) {
            print("Error parsing size JSON: $e");
          }
          // If parsing fails, set the original value
          itemSpecificationController.text = widget.productDetail!.size!;
        }
      }
    }
  }

  Future<void> _pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _selectedImages
            .addAll(result.files.map((file) => file.bytes!).toList());
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
        key: _formKey,
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
              controller: itemNameController,
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
              controller: itemPriceController,
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
              controller: itemDescController,
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
              controller: itemSpecificationController,
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
                if (_formKey.currentState!.validate()) {
                  // Check if the product ID is null
                  final id = widget.productDetail?.id;
                  if (id == null) {
                    print('Error: Product ID is missing. Cannot update.');
                    return;
                  }

                  // Check if the selected category is null
                  final itemTitle = productDetailController.selectedCategory;
                  if (itemTitle == null) {
                    print('Error: Please select a category.');
                    return;
                  }

                  // Prepare the data for the API request
                  final itemName = itemNameController.text;
                  final itemPrice = itemPriceController.text;
                  final itemDesc = itemDescController.text;
                  final itemSize = itemSpecificationController.text;

                  // Print the data for debugging
                  print('ID: $id');
                  print('Item Title: $itemTitle');
                  print('Item Name: $itemName');
                  print('Item Price: $itemPrice');
                  print('Item Desc: $itemDesc');
                  print('Item Size: $itemSize');
                  print('Number of Images: ${_selectedImages.length}');

                  // Call the API to update the product details
                  final success = await ApiService.updateJewelleryDetails(
                    id: id,
                    itemTitle: itemTitle,
                    itemName: itemName,
                    itemPrice: itemPrice,
                    itemDesc: itemDesc,
                    itemSize: itemSize,
                    itemImages: _selectedImages,
                    context: context, // Pass the BuildContext here
                  );

                  // Handle the API response
                  if (success) {
                    print('Success: Product details updated successfully!');
                  } else {
                    print(
                        'Error: Failed to update product details. Please try again.');
                  }
                }
              },
              child: const Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}
