import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductController extends GetxController {
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  // Properties to hold server response
  String? serverResponse; // Store the message returned from the server
  bool isSuccess = false; // Flag to indicate success or failure

  // Add Product method
  Future<void> addProduct({
    required String productName,
    required int quantity,
    required double price,
    required String description,
    required String? category,
  }) async {
    final url = Uri.parse('http://localhost/student_insertion/add_product.php'); // Replace with your API URL

    print('Attempting to add product...');
    print('Product Name: $productName');
    print('Quantity: $quantity');
    print('Price: $price');
    print('Description: $description');
    print('Category: $category');

    try {
      final response = await http.post(
        url,
        body: {
          'product_name': productName,
          'quantity': quantity.toString(),
          'price': price.toString(),
          'description': description,
          'godown': category ?? '',
        },
      );

      // Print the response status code and body
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Assuming the response is a success message or JSON
        final responseBody = response.body; // Assuming this contains a JSON response
        print('Server Response: $responseBody');

        serverResponse = responseBody; // Store the server response message
        isSuccess = true; // Set success flag
      } else {
        print('Failed to add product. Response body: ${response.body}');
        serverResponse = 'Failed to add product: ${response.body}';
        isSuccess = false; // Set failure flag
      }
    } catch (e) {
      // Catch any errors and print them
      print('Error occurred: $e');
      serverResponse = 'An error occurred: $e';
      isSuccess = false;
    }

    update(); // Notify listeners to refresh UI if necessary
  }


}
