import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AddBannerController extends GetxController {
  final formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> categories = [];
  String? selectedCategory;

  final itemTitleController = TextEditingController();

  @override
  void onClose() {

    itemTitleController.dispose();

    super.onClose();
  }

  void clearFormFields() {

    selectedCategory = null;
  }
}
