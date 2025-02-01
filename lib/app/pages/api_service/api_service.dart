import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import '../tables_page/jewellery_banner_table.dart';
import '../tables_page/jewellery_details_table.dart';
import '../tables_page/jewellery_home_page_table.dart';

class ApiService {
  static const String _baseUrl = 'http://localhost/jewellary';
  static void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static dynamic handleResponse(http.Response response, BuildContext context) {
    var data = json.decode(response.body);
    if (data['status'] == 'success') {
      if (kDebugMode) print(data['message'] ?? 'Success');
      showSnackBar(context, data['message'] ?? 'Success', Colors.green);
      return data;
    } else {
      if (kDebugMode) print(data['message'] ?? 'Error');

      showSnackBar(context, data['message'] ?? 'Error', Colors.red);
      return null;
    }
  }

  // Fetch banner images
  static Future<List<User>> fetchJewellaryBannerImages() async {
    const apiUrl = '$_baseUrl/get_jewellary_banner.php';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        // print(jsonResponse);
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((item) {
            return User(
              isSelected: false,
              id: int.parse(
                  item['id'].toString()), // Ensure id is parsed as int
              name: item['item_title'],
              images: (item['jewellary_banner'] as String).split(', '),
            );
          }).toList();
        } else {
          throw Exception('Error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load banners. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching banners: $e');
    }
  }

  // Fetch Home Page Detail
  static Future<List<UserHomePage>> fetchJewellaryHomePage() async {
    const apiUrl = '$_baseUrl/get_jewellary_homepage.php';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        // print(jsonResponse);
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((item) {
            return UserHomePage(
              isSelected: false,
              id: int.parse(
                  item['id'].toString()), // Ensure id is parsed as int
              name: item['item_title'],
              images: (item['jewellary_home_img'] as String).split(', '),
            );
          }).toList();
        } else {
          throw Exception('Error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to load banners. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching banners: $e');
    }
  }

  static Future<List<UserProductDetail>> fetchJewellaryDetails() async {
    const apiUrl = '$_baseUrl/get_jewellery_detail_admin.php';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        // print(jsonResponse);
        if (jsonResponse['status'] == 'success') {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((item) {
            return UserProductDetail(
              isSelected: false,
              id: int.parse(
                  item['id'].toString()), // Ensure id is parsed as int
              title: item['item_title'],
              name: item['item_name'],
              price: item['item_price'],
              size: item['item_size'],
              desc: item['item_desc'],
              images: (item['item_img'] as String).split(','),
            );
          }).toList();
        } else {
          throw Exception('Error: ${jsonResponse['message']}');
        }
      } else {
        throw Exception(
            'Failed to fetch product details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching product details: $e');
    }
  }

  // Jewellary Categories Image for Home Page
  static Future<List<Map<String, dynamic>>>
      fetchJewellaryCategoryImages() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/get_jewellary_homepage.php'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('API Response: $data'); // Print the response to inspect

        // Extract the 'data' field containing the list of category items
        if (data['data'] != null) {
          return List<Map<String, dynamic>>.from(
            data['data'].map((item) => {
                  'jewellary_home_img': item['jewellary_home_img'] ?? '',
                  'item_title': item['item_title'] ?? '',
                }),
          );
        } else {
          throw Exception('No category images found');
        }
      } else {
        throw Exception('Failed to load images');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching category images: $e');
      }
      return [];
    }
  }

  static Future<bool> addProductDetail(
    BuildContext context,
    String itemTitle,
    String itemName,
    String itemPrice,
    String itemDesc,
    String itemSpecification,
    List<Uint8List> images, // Accepts images in Uint8List format
  ) async {
    try {
      Uri url = Uri.parse('$_baseUrl/insert_jewellary_detail.php');
      var request = http.MultipartRequest('POST', url);

      // Add text fields to the request
      request.fields['item_title'] = itemTitle;
      request.fields['item_name'] = itemName;
      request.fields['item_price'] = itemPrice;
      request.fields['item_desc'] = itemDesc;
      request.fields['item_size'] = itemSpecification;

      // Upload multiple images

      for (int i = 0; i < images.length; i++) {
        final multipartFile = http.MultipartFile.fromBytes(
          'item_img[]',
          images[i],
          filename: 'image_$i.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();

      print('Response status: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');

      // Check the status code and return true/false based on the result
      if (response.statusCode == 201) {
        return true; // Return true if successful
      }

      return false; // Return false if the status code indicates failure
    } catch (e) {
      print('Error: $e');
      return false; // Return false in case of error
    }
  }

  static Future<bool> addBanner(
    BuildContext context,
    String itemTitle,
    List<Uint8List> images, // Accepts images in Uint8List format
  ) async {
    try {
      Uri url = Uri.parse('$_baseUrl/insert_jewellary_banner.php');
      var request = http.MultipartRequest('POST', url);

      // Add text fields to the request
      request.fields['item_title'] = itemTitle;

      // Add images to the request
      // Upload multiple images

      for (int i = 0; i < images.length; i++) {
        final multipartFile = http.MultipartFile.fromBytes(
          'jewellary_banner[]',
          images[i],
          filename: 'image_$i.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();

      print('Response status: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');

      // Check the status code and return true/false based on the result
      if (response.statusCode == 201) {
        return true; // Return true if successful
      }

      return false; // Return false if the status code indicates failure
    } catch (e) {
      print('Error: $e');
      return false; // Return false in case of error
    }
  }

  static Future<bool> addHomePage(
    BuildContext context,
    String itemTitle,
    List<Uint8List> images, // Accepts images in Uint8List format
  ) async {
    try {
      Uri url = Uri.parse('$_baseUrl/insert_jewellary_homepage.php');
      var request = http.MultipartRequest('POST', url);

      // Add text fields to the request
      request.fields['item_title'] = itemTitle;

      // Add images to the request
      // Upload multiple images

      for (int i = 0; i < images.length; i++) {
        final multipartFile = http.MultipartFile.fromBytes(
          'jewellary_home_img[]',
          images[i],
          filename: 'image_$i.jpg',
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();

      print('Response status: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');

      // Check the status code and return true/false based on the result
      if (response.statusCode == 201) {
        return true; // Return true if successful
      }

      return false; // Return false if the status code indicates failure
    } catch (e) {
      print('Error: $e');
      return false; // Return false in case of error
    }
  }

  static Future<bool> updateJewelleryDetails({
    required int id,
    required String itemTitle,
    required String itemName,
    required String itemPrice,
    required String itemDesc,
    required String itemSize,
    required List<Uint8List> itemImages,
    required BuildContext context,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl/edit_jewellery_details.php');
      final request = http.MultipartRequest('POST', uri);

      // Add fields
      request.fields['id'] = id.toString();
      request.fields['item_title'] = itemTitle;
      request.fields['item_name'] = itemName;
      request.fields['item_price'] = itemPrice;
      request.fields['item_desc'] = itemDesc;
      request.fields['item_size'] = itemSize;

      // Add images
      for (int i = 0; i < itemImages.length; i++) {
        request.files.add(http.MultipartFile.fromBytes(
          'item_img[]',
          itemImages[i],
          filename: 'image_$i.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);

      if (context.mounted) {
        showSnackBar(
          context,
          jsonResponse['message'] ?? 'Unexpected response from the server.',
          response.statusCode == 201 ? Colors.green : Colors.red,
        );
      }

      return response.statusCode == 201;
    } catch (e) {
      print('Error updating jewellery details: $e');
      if (context.mounted) {
        showSnackBar(context, 'An error occurred: $e', Colors.red);
      }
      return false;
    }
  }
  static Future<void> deleteProduct(BuildContext context, int id) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/delete_product_details.php'),
        headers: <String, String>{
          'Content-Type': 'application/x-www-form-urlencoded', // Use form-urlencoded
        },
        body: {
          'id': id.toString(), // Send the ID as a POST parameter
        },
      );

      if (response.statusCode == 200) {
        // Product deleted successfully
        final responseData = jsonDecode(response.body);
        showSnackBar(context, responseData['message'], Colors.green);
        print("Product deleted successfully");
        print("Response: ${response.body}");
      } else {
        // Handle errors
        final responseData = jsonDecode(response.body);
        showSnackBar(context, responseData['message'], Colors.red);
        print("Failed to delete product. Error: ${response.body}");
      }
    } catch (e) {
      // Handle exceptions
      showSnackBar(context, "An error occurred: $e", Colors.red);
      print("Exception occurred: $e");
    }
  }
}
