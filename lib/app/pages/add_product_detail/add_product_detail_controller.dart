import 'package:acnoo_flutter_admin_panel/app/pages/add_product_detail/add_product_detail_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../component/unique_id.dart';
import '../api_service/api_service.dart';

class ProductDetailController extends GetxController {

  final formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> categories = [];
  String? selectedCategory;

  final itemNameController = TextEditingController();
  final itemSpecificationController = TextEditingController();
  final itemPriceController = TextEditingController();
  final itemDescController = TextEditingController();
  final itemTitleController = TextEditingController();

  @override
  void onClose() {
    // Dispose controllers when the controller is closed
    itemNameController.dispose();
    itemSpecificationController.dispose();
    itemPriceController.dispose();
    itemDescController.dispose();
    itemTitleController.dispose();

    super.onClose();
  }

  void clearFormFields() {
    itemNameController.clear();
    itemSpecificationController.clear();
    itemPriceController.clear();
    itemDescController.clear();
    selectedCategory = null;
  }
}
