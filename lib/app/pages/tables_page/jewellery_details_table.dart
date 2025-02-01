import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:responsive_grid/responsive_grid.dart';
import '../../../component/elevated_button.dart';
import '../../../generated/l10n.dart' as l;

import '../../widgets/shadow_container/_shadow_container.dart';
import '../api_service/api_service.dart';
import '../edit_product_details/edit_product_details_ui.dart';

class JewelleryDetailsTable extends StatefulWidget {
  const JewelleryDetailsTable({super.key});

  @override
  State<JewelleryDetailsTable> createState() => _JewelleryDetailsTableState();
}

class _JewelleryDetailsTableState extends State<JewelleryDetailsTable> {
  List<String> _bannerImages = [];
  bool _isLoading = true;
  bool _selectAll = false;
  List<UserProductDetail> _users = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    try {
      final users = await ApiService.fetchJewellaryDetails();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  void _selectAllRows(bool select) {
    setState(() {
      _selectAll = select;
      for (var user in _users) {
        user.isSelected = select;
      }
    });
  }

  void _editUserProduct(UserProductDetail userProductDetail) {
    // Navigate to the edit route and pass the product details
    context.go(
      '/tables/edit-product-details',
      extra: userProductDetail, // Pass the product details as an extra
    );
  }

  // Function to show image in full size
  void _showFullSizeImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Close the dialog on tap
            },
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final _padding = responsiveValue<double>(
      context,
      xs: 16 / 2,
      sm: 16 / 2,
      md: 16 / 2,
      lg: 24 / 2,
    );
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(_padding),
        child: ResponsiveGridRow(
          children: [
            ///-----------------------------Table_Head
            tableHead(_padding, context, theme, textTheme),
          ],
        ),
      ),
    );
  }

  ResponsiveGridCol tableHead(
    double _padding,
    BuildContext context,
    ThemeData theme,
    TextTheme textTheme,
  ) {
    final lang = l.S.of(context);
    return ResponsiveGridCol(
      child: ShadowContainer(
        margin: EdgeInsetsDirectional.all(_padding),
        contentPadding: EdgeInsetsDirectional.only(
          bottom: _padding * 2,
        ),
        headerText: lang.tableHead,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                ),
                child: Theme(
                  data: ThemeData(
                    dividerColor: theme.colorScheme.outline,
                    checkboxTheme: CheckboxThemeData(
                      side: BorderSide(
                        color: theme.colorScheme.outline,
                        width: 1.0,
                      ),
                    ),
                    dividerTheme: DividerThemeData(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  child: DataTable(
                    dividerThickness: 1,
                    headingTextStyle: textTheme.titleMedium,
                    dataTextStyle: textTheme.bodyLarge,
                    horizontalMargin: 16.0,
                    dataRowMaxHeight: 150,
                    headingRowColor: WidgetStateProperty.all(
                      theme.colorScheme.surface,
                    ),
                    columns: [
                      DataColumn(
                        label: Row(
                          children: [
                            Checkbox(
                              value: _selectAll,
                              onChanged: (value) {
                                _selectAllRows(value ?? false);
                              },
                            ),
                            const SizedBox(width: 12.0),
                            Text('${lang.SL}.'),
                          ],
                        ),
                      ),
                      DataColumn(label: Text(lang.title)),
                      DataColumn(label: Text(lang.name)),
                      DataColumn(label: Text(lang.price)),
                      // DataColumn(label: Text(lang.description)),
                      // DataColumn(label: Text(lang.size)),
                      DataColumn(label: Text(lang.img)),
                      DataColumn(label: Text(lang.edit)),
                      DataColumn(label: Text(lang.delete)),
                    ],
                    rows: _users.map(
                      (user) {
                        return DataRow(
                          selected: user.isSelected,
                          cells: [
                            DataCell(
                              Row(
                                children: [
                                  Checkbox(
                                    value: user.isSelected,
                                    onChanged: (selected) {
                                      setState(() {
                                        user.isSelected = selected ?? false;
                                        _selectAll =
                                            _users.every((u) => u.isSelected);
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 12.0),
                                  Text(
                                    user.id.toString(),
                                    style: textTheme.bodyMedium,
                                  )
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                user.title,
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            DataCell(
                              Text(
                                user.name,
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            DataCell(
                              Text(
                                user.price,
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            // DataCell(
                            //   Text(
                            //     user.size,
                            //     style: textTheme.bodyMedium,
                            //   ),
                            // ),
                            // DataCell(
                            //   Text(
                            //     user.desc,
                            //     style: textTheme.bodyMedium,
                            //   ),
                            // ),
                            DataCell(
                              Container(
                                width: 150, // Fixed width for the container
                                height: 100, // Fixed height for the container
                                decoration: BoxDecoration(
                                  border: Border.all(color: theme.colorScheme.outline),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: user.images.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          _showFullSizeImage(context, user.images[index]);
                                        },
                                        child: Image.network(
                                          user.images[index],
                                          width: 100, // Fixed width for each image
                                          height: 100, // Fixed height for each image
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(Icons.error); // Show an error icon if the image fails to load
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            DataCell(
                              CustomButton(
                                label: "Edit",
                                onPressed: () {
                                  _editUserProduct(user);
                                },
                              ),
                            ),
                            DataCell(
                              CustomButton(
                                label: "Delete",
                                onPressed: () async {
                                  await ApiService.deleteProduct(context,user.id);
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class UserProductDetail {
  bool isSelected;
  final int id;
  final String title;
  final String name;
  final String price;
  final String size;
  final String desc;
  final List<String> images; // List of image URLs

  UserProductDetail({
    required this.isSelected,
    required this.id,
    required this.title,
    required this.name,
    required this.price,
    required this.size,
    required this.desc,
    required this.images, // Initialize with a list of URLs
  });
}
