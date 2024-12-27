import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> deleteProduct(BuildContext context, int userId) async {
  // Show a confirmation dialog before deletion
  bool? confirmDelete = await showDialog(
    context: context,

    builder: (context) => AlertDialog(
      title: Text('Are you sure?'),
      content: Text('Do you want to delete this product?'),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Close dialog and return false (do not delete)
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Close dialog and return true (delete)
          },
          child: Text('Delete'),
        ),
      ],
    ),
  );

  // If the user confirmed the deletion, proceed with the request
  if (confirmDelete == true) {
    // Proceed with deleting the product using GET method
    final url = Uri.parse('http://localhost/student_insertion/delete.php?id=$userId');
    print("Deleting product at: $url"); // Debug: print the URL

    try {
      final response = await http.get(url);

      print("Response Status: ${response.statusCode}"); // Debug: pri
      // nt status code
      print("Response Body: ${response.body}"); // Debug: print response body

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Response Data: $data"); // Debug: print parsed response data

        // Check if the response status is 'success'
        if (data['status'] == 'success') {
          // Show success message in a dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Success'),
              content: Text(data['message'] ?? 'Product deleted successfully'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        } else {
          // Show failure message in a dialog
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Response'),
              content: Text(data['message'] ?? 'Failed to delete product'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
      } else {
        // Handle server error if the status code is not 200
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Response'),
            content: Text('Error deleting product: ${response.body}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error: $e"); // Debug: print exception error
      // Handle any other exceptions
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Response'),
          content: Text('An error occurred: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
