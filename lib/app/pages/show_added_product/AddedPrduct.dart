import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String productName;
  final int quantity;
  final double price;
  final String description;
  final String? category;
  final List<dynamic>? images; // Supports both web and mobile images

  const ProductDetailsScreen({
    Key? key,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.description,
    this.category,
    this.images,
  }) : super(key: key);

  Widget buildImage(dynamic image) {
    // Display images based on platform (web or mobile)
    if (kIsWeb && image is PlatformFile) {
      return Image.memory(image.bytes!, fit: BoxFit.cover);
    } else if (!kIsWeb && image is XFile) {
      return Image.file(File(image.path), fit: BoxFit.cover);
    }
    return const SizedBox(); // Fallback for unsupported image type
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Name: $productName',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Category: ${category ?? "N/A"}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Quantity: $quantity',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Price: \$${price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Description:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (images != null && images!.isNotEmpty) ...[
              const Text(
                'Images:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: images!
                    .map((image) => ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: buildImage(image),
                  ),
                ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
