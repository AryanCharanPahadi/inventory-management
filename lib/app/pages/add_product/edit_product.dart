// import 'package:acnoo_flutter_admin_panel/app/pages/add_product/edit_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
//
// import 'add_product_controller.dart';
//
// class EditProductForm extends StatefulWidget {
//   final int id;
//   final String initialGodown;
//   final String initialProductName;
//   final String initialQuantity;
//   final String initialPrice;
//   final String initialDescription;
//
//   const EditProductForm({
//     required this.id,
//     required this.initialGodown,
//     required this.initialProductName,
//     required this.initialQuantity,
//     required this.initialPrice,
//     required this.initialDescription,
//   });
//
//   @override
//   State<EditProductForm> createState() => _EditProductFormState();
// }
//
// class _EditProductFormState extends State<EditProductForm> {
//   ProductController productController = Get.put(ProductController());
//   final List<String> categories = ['Gurugram', 'Delhi', 'Noida', 'Saket'];
//   String? _godownController;
//   final _formKey = GlobalKey<FormState>();
//
//   final _productNameController = TextEditingController();
//   final _quantityController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _descriptionController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     // Ensure the initial value matches one of the categories
//     if (categories.contains(widget.initialGodown)) {
//       _godownController = widget.initialGodown;
//     } else {
//       _godownController = null; // Set to null if not valid
//     }
//     _productNameController.text = widget.initialProductName;
//     _quantityController.text = widget.initialQuantity;
//     _priceController.text = widget.initialPrice;
//     _descriptionController.text = widget.initialDescription;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(screenWidth < 600 ? 16.0 : 32.0),
//       child: Form(
//         key: _formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             DropdownButtonFormField<String>(
//               value: _godownController,
//               onChanged: (newValue) {
//                 setState(() {
//                   _godownController = newValue;
//                 });
//               },
//               items: categories.map((category) {
//                 return DropdownMenuItem<String>(
//                   value: category,
//                   child: Text(category),
//                 );
//               }).toList(),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please select a category';
//                 }
//                 return null;
//               },
//               decoration: InputDecoration(
//                 labelText: 'Select Godown',
//                 suffixIcon: const Icon(Icons.warehouse, size: 20),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _productNameController,
//               decoration: InputDecoration(
//                 labelText: 'Product Name',
//                 suffixIcon: const Icon(Icons.edit, size: 20),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a product name';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _quantityController,
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
//               ],
//               decoration: InputDecoration(
//                 labelText: 'Quantity',
//                 suffixIcon: const Icon(Icons.add_circle_outline, size: 20),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a quantity';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _priceController,
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
//               ],
//               decoration: InputDecoration(
//                 labelText: 'Price',
//                 suffixIcon: const Icon(Icons.attach_money, size: 20),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a price';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               controller: _descriptionController,
//               maxLines: 3,
//               decoration: InputDecoration(
//                 labelText: 'Description',
//                 suffixIcon: const Icon(Icons.description, size: 20),
//               ),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter description';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () async {
//                 if (_formKey.currentState!.validate()) {
//                   final controller = UpdateProductController();
//                   await controller.updateProduct(
//                     id: widget.id,
//                     godown: _godownController!,
//                     productName: _productNameController.text,
//                     quantity: _quantityController.text,
//                     price: _priceController.text,
//                     description: _descriptionController.text,
//                     context: context,
//                   );
//                   Navigator.of(context).pop(); // Close the dialog
//                 }
//               },
//               child: Text('Update'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
