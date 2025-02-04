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
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  List<UserProductDetail> _filteredUsers = [];
  bool _isRefreshing = false; // Add this line

  @override
  void initState() {
    super.initState();
    _fetchHomePage();
  }

  Future<void> _fetchHomePage() async {
    setState(() {
      _isRefreshing = true; // Set refreshing to true
    });
    try {
      final users = await ApiService.fetchJewellaryDetails();
      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
        _isRefreshing = false; // Set refreshing to false after data is fetched
      });
      // print('Fetched product details length: ${users.length}'); // Print the length of the fetched data
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isRefreshing = false; // Set refreshing to false in case of error
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

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
        _filteredUsers = _users;
      }
    });
  }

  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredUsers = _users; // Reset to full list when query is empty
      } else {
        _filteredUsers = _users
            .where((user) =>
                user.name.toLowerCase().contains(query.toLowerCase()) ||
                user.title.toLowerCase().contains(query.toLowerCase()) ||
                user.price.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isSearchVisible)
              SizedBox(
                width: 200,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                  ),
                  onChanged: _filterUsers,
                ),
              ),
            IconButton(
              onPressed: _toggleSearch,
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                _fetchHomePage();
              },
              icon: _isRefreshing
                  ? const CircularProgressIndicator() // Show circular loader when refreshing
                  : const Icon(Icons.refresh),
            ),
          ],
        ),
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
                      DataColumn(label: Text(lang.img)),
                      DataColumn(label: Text(lang.edit)),
                      DataColumn(label: Text(lang.delete)),
                    ],
                    rows: _filteredUsers.map(
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
                                        _selectAll = _filteredUsers
                                            .every((u) => u.isSelected);
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 12.0),
                                  SelectableText(
                                    user.id.toString(),
                                    style: textTheme.bodyMedium,
                                  )
                                ],
                              ),
                            ),
                            DataCell(
                              SelectableText(
                                user.title,
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            DataCell(
                              SelectableText(
                                user.name,
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            DataCell(
                              SelectableText(
                                user.price,
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            DataCell(
                              Container(
                                width: 150,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: theme.colorScheme.outline),
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
                                          _showFullSizeImage(
                                              context, user.images[index]);
                                        },
                                        child: Image.network(
                                          user.images[index],
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(Icons.error);
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
                                  await ApiService.deleteProduct(
                                      context, user.id);
                                  await _fetchHomePage();
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
  final List<String> images;

  UserProductDetail({
    required this.isSelected,
    required this.id,
    required this.title,
    required this.name,
    required this.price,
    required this.size,
    required this.desc,
    required this.images,
  });
}
