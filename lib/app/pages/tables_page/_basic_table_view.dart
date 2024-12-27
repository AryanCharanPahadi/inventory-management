// 🐦 Flutter imports:
import 'dart:convert';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

// 📦 Package imports:

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../widgets/shadow_container/_shadow_container.dart';
import '../add_product/delete_product.dart';
import '../add_product/edit_product.dart';

class BasicTableView extends StatefulWidget {
  const BasicTableView({super.key});

  @override
  State<BasicTableView> createState() => _BasicTableViewState();
}

class _BasicTableViewState extends State<BasicTableView> {
  bool _selectAll = false;
  final List<User> _users = [];
  bool _isLoading = true;

  // Track column visibility
  final Map<String, bool> _columnsVisibility = {
    "SL": true,
    "Godown": true,
    "Product Name": true,
    "Quantity": true,
    "Price": true,
    "Description": true,
    "Edit": true,
    "Delete": true,
  };

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse('http://localhost/student_insertion/select.php');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 'success') {
          final List<dynamic> products = data['data'];

          setState(() {
            _users.clear();
            _users.addAll(products.map((item) => User.fromJson(item)));
            _isLoading = false;
          });
        } else {
          showError(data['message'] ?? 'Failed to fetch data');
        }
      } else {
        showError('Server returned an error: ${response.statusCode}');
      }
    } catch (e) {
      showError('An error occurred: $e');
    }
  }

  void showError(String message) {
    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  void _selectAllRows(bool select) {
    setState(() {
      _selectAll = select;
      for (var user in _users) {
        user.isSelected = select;
      }
    });
  }

  Future<void> _downloadExcel() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final excel = Excel.createExcel();
      final sheet = excel['Sheet1'];

      // Add header row
      final headers = _columnsVisibility.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();
      sheet.appendRow(headers);

      // Add data rows
      for (var user in _users) {
        final row = [];
        if (_columnsVisibility["SL"]!) row.add(user.id.toString());
        if (_columnsVisibility["Godown"]!) row.add(user.godown);
        if (_columnsVisibility["Product Name"]!) row.add(user.productName);
        if (_columnsVisibility["Quantity"]!) row.add(user.quantity);
        if (_columnsVisibility["Price"]!) row.add(user.price);
        if (_columnsVisibility["Description"]!) row.add(user.description);
        sheet.appendRow(row);
      }

      // Save the file
      final fileBytes = excel.save();
      final directory = Directory('/storage/emulated/0/Download');
      final filePath = '${directory.path}/ProductList.xlsx';
      final file = File(filePath);
      await file.writeAsBytes(fileBytes!);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('File saved to $filePath'),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Storage permission denied'),
        backgroundColor: Colors.red,
      ));
    }
  }

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Scaffold(
        appBar: AppBar(
          title: Text(lang.addedProduct),
          actions: [
            // Search field
            SizedBox(
              width: 200,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    if (value.isEmpty) {
                      // Show all data when search field is cleared
                      _users.clear();
                      fetchData();
                    } else {
                      // Filter users based on search input
                      final keyword = value.toLowerCase();
                      _users.retainWhere((user) =>
                          user.godown.toLowerCase().contains(keyword) ||
                          user.productName.toLowerCase().contains(keyword) ||
                          user.quantity.toLowerCase().contains(keyword) ||
                          user.price.toLowerCase().contains(keyword) ||
                          user.description.toLowerCase().contains(keyword));
                    }
                  });
                },
                decoration: InputDecoration(
                  hintText: lang.search, // Localized search label
                  hintStyle: textTheme.bodySmall,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),

                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _isLoading =
                      true; // Show loading indicator while fetching data
                });
                fetchData(); // Trigger data fetch
              },
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) {
                return _columnsVisibility.keys.map((columnName) {
                  return PopupMenuItem<String>(
                    value: columnName,
                    child: StatefulBuilder(
                      builder: (context, setStateInsidePopup) {
                        return CheckboxListTile(
                          title: Text(columnName),
                          value: _columnsVisibility[columnName],
                          onChanged: (isChecked) {
                            setState(() {
                              _columnsVisibility[columnName] =
                                  isChecked ?? true;
                            });
                            setStateInsidePopup(
                                () {}); // Ensures immediate UI update inside the popup
                          },
                        );
                      },
                    ),
                  );
                }).toList();
              },
            ),
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: _downloadExcel,
            ),
          ],
        ),
        body: ShadowContainer(
          contentPadding:
              const EdgeInsets.all(8.0), // Keep some margin for aesthetics
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _users.isEmpty
                  ? Center(
                      child: Text(
                        'No match found', // Text to show if no match is found
                        style: textTheme.titleMedium,
                      ),
                    )
                  : LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Scrollbar(
                          controller: _horizontalScrollController,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: _horizontalScrollController,
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth,
                              ),
                              child: Scrollbar(
                                controller: _verticalScrollController,
                                thumbVisibility: true,
                                child: SingleChildScrollView(
                                  controller: _verticalScrollController,
                                  child: DataTable(
                                    headingRowColor: WidgetStateProperty.all(
                                      theme.colorScheme.surface,
                                    ),
                                    showCheckboxColumn: false,
                                    headingTextStyle: textTheme.titleMedium,
                                    dataTextStyle: textTheme.bodySmall,
                                    columns: [
                                      if (_columnsVisibility["SL"]!)
                                        DataColumn(
                                          label: Row(
                                            children: [
                                              Checkbox(
                                                value: _selectAll,
                                                onChanged: (value) {
                                                  _selectAllRows(
                                                      value ?? false);
                                                },
                                              ),
                                              const SizedBox(width: 12.0),
                                              Text('${lang.SL}.'),
                                            ],
                                          ),
                                        ),
                                      if (_columnsVisibility["Godown"]!)
                                        DataColumn(label: Text(lang.godown)),
                                      if (_columnsVisibility["Product Name"]!)
                                        DataColumn(
                                            label: Text(lang.product_name)),
                                      if (_columnsVisibility["Quantity"]!)
                                        DataColumn(
                                            label: Text(lang.quantity_product)),
                                      if (_columnsVisibility["Price"]!)
                                        DataColumn(
                                            label: Text(lang.price_product)),
                                      if (_columnsVisibility["Description"]!)
                                        DataColumn(
                                            label:
                                                Text(lang.description_product)),
                                      if (_columnsVisibility["Edit"]!)
                                        const DataColumn(label: Text('Edit')),
                                      if (_columnsVisibility["Delete"]!)
                                        const DataColumn(label: Text('Delete')),
                                    ],
                                    rows: _users.map((user) {
                                      return DataRow(
                                        color: WidgetStateProperty
                                            .resolveWith<Color?>(
                                          (Set<WidgetState> states) {
                                            if (states.contains(
                                                WidgetState.hovered)) {
                                              return isDark
                                                  ? const Color(0xFF334155)
                                                  : const Color(0xFFF8F8F8);
                                            }
                                            return null;
                                          },
                                        ),
                                        selected: user.isSelected,
                                        cells: [
                                          if (_columnsVisibility["SL"]!)
                                            DataCell(
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    value: user.isSelected,
                                                    onChanged: (selected) {
                                                      setState(() {
                                                        user.isSelected =
                                                            selected ?? false;
                                                        _selectAll =
                                                            _users.every((u) =>
                                                                u.isSelected);
                                                      });
                                                    },
                                                  ),
                                                  const SizedBox(width: 12.0),
                                                  Text(user.id.toString(),
                                                      style:
                                                          textTheme.bodyMedium),
                                                ],
                                              ),
                                            ),
                                          if (_columnsVisibility["Godown"]!)
                                            DataCell(Text(
                                              toProperCase(user.godown),
                                              style: textTheme.bodyMedium,
                                            )),
                                          if (_columnsVisibility[
                                              "Product Name"]!)
                                            DataCell(Text(
                                              toProperCase(user.productName),
                                              style: textTheme.bodyMedium,
                                            )),
                                          if (_columnsVisibility["Quantity"]!)
                                            DataCell(Text(
                                              toProperCase(user.quantity),
                                              style: textTheme.bodyMedium,
                                            )),
                                          if (_columnsVisibility["Price"]!)
                                            DataCell(Text(
                                              toProperCase(user.price),
                                              style: textTheme.bodyMedium,
                                            )),
                                          if (_columnsVisibility[
                                              "Description"]!)
                                            DataCell(Text(
                                              toProperCase(user.description),
                                              style: textTheme.bodyMedium,
                                            )),
                                          DataCell(
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProductForm(
                                                      id: user.id,
                                                      initialDescription:
                                                          user.description,
                                                      initialGodown:
                                                          user.godown,
                                                      initialPrice: user.price,
                                                      initialProductName:
                                                          user.productName,
                                                      initialQuantity:
                                                          user.quantity,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: const Text('Edit'),
                                            ),
                                          ),
                                          DataCell(
                                            ElevatedButton(
                                              onPressed: () async {
                                                await deleteProduct(context,
                                                    user.id); // Call the deleteProduct function
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          )
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),

                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}

// User model
class User {
  bool isSelected;
  int id;
  String godown;
  String productName;
  String quantity;
  String price;
  String description;

  User({
    required this.isSelected,
    required this.id,
    required this.godown,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.description,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      isSelected: false,
      id: json['id'],
      godown: json['godown'],
      productName: json['product_name'],
      quantity: json['quantity'],
      price: json['price'],
      description: json['description'],
    );
  }
}

String toProperCase(String text) {
  if (text.isEmpty) return text;
  return text.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}
