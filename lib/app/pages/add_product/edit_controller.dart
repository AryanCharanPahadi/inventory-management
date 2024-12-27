import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateProductController {
  static const String _baseUrl =
      'http://localhost/student_insertion/update.php';

  Future<void> updateProduct({
    required int id,
    required String godown,
    required String productName,
    required String quantity,
    required String price,
    required String description,
    required BuildContext context,
  }) async {
    final url = Uri.parse(_baseUrl);

    try {
      print('Sending request to: $url'); // Print the request URL
      print('Request body: ${json.encode({
            "id": id,
            "godown": godown,
            "product_name": productName,
            "quantity": quantity,
            "price": price,
            "description": description,
          })}'); // Print the body of the request

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "id": id,
          "godown": godown,
          "product_name": productName,
          "quantity": quantity,
          "price": price,
          "description": description,
        }),
      );

      print(
          'Response status: ${response.statusCode}'); // Print the status code of the response

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Response body: $data'); // Print the response body

        // Show the response message in a dialog
        _showResponseDialog(context, data['message']);
      } else {
        throw Exception('Failed to update product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e'); // Print error
      // Show error message in a dialog
      _showResponseDialog(context, 'An error occurred: $e');
    }
  }

  void _showResponseDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Response'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
