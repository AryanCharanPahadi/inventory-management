import 'package:acnoo_flutter_admin_panel/component/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../generated/l10n.dart' as l;
import '../../widgets/shadow_container/_shadow_container.dart';
import '../api_service/api_service.dart';

class JewelleryHomePageTable extends StatefulWidget {
  const JewelleryHomePageTable({super.key});

  @override
  State<JewelleryHomePageTable> createState() => _JewelleryHomePageTableState();
}

class _JewelleryHomePageTableState extends State<JewelleryHomePageTable> {
  List<String> _bannerImages = [];
  bool _isLoading = true;
  bool _selectAll = false;
  List<UserHomePage> _users = [];
  List<UserHomePage> _filteredUsers = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;
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
      final users = await ApiService.fetchJewellaryHomePage();
      setState(() {
        _users = users;
        _filteredUsers = users;
        _isLoading = false;
        _isRefreshing = false; // Set refreshing to false after data is fetched
      });
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
      for (var user in _filteredUsers) {
        user.isSelected = select;
      }
    });
  }

  void _editUserProduct(UserHomePage userHomePage) {
    // Navigate to the edit route and pass the product details
    context.go(
      '/tables/edit-product-homePage',
      extra: userHomePage, // Pass the product details as an extra
    );
  }

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
      _filteredUsers = _users
          .where(
              (user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
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
                    dataTextStyle: textTheme.bodySmall,
                    horizontalMargin: 16.0,
                    dataRowMaxHeight: 100,
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
                      DataColumn(label: Text(lang.name)),
                      DataColumn(label: Text(lang.img)),
                      DataColumn(label: Text(lang.edit)),
                      DataColumn(label: Text(lang.delete)),
                    ],
                    rows: _filteredUsers.isEmpty
                        ? [
                            DataRow(
                              cells: [
                                DataCell(
                                  Center(
                                    child: Text(
                                      'No data available',
                                      style: textTheme.bodyMedium,
                                    ),
                                  ),
                                ),
                                DataCell(Container()), // Empty cell
                                DataCell(Container()), // Empty cell
                                DataCell(Container()), // Empty cell
                                DataCell(Container()), // Empty cell
                              ],
                            ),
                          ]
                        : _filteredUsers.map(
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
                                              user.isSelected =
                                                  selected ?? false;
                                              _selectAll = _filteredUsers
                                                  .every((u) => u.isSelected);
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
                                      user.name,
                                      style: textTheme.bodyMedium,
                                    ),
                                  ),
                                  DataCell(
                                    Wrap(
                                      spacing:
                                          8.0, // Horizontal space between images
                                      runSpacing:
                                          8.0, // Vertical space between images
                                      children: user.images.map((imageUrl) {
                                        return GestureDetector(
                                          onTap: () {
                                            _showFullSizeImage(
                                                context, imageUrl);
                                          },
                                          child: Image.network(
                                            imageUrl,
                                            width: 100, // Adjust as needed
                                            height: 100, // Adjust as needed
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }).toList(),
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
                                        await ApiService.deleteProductHomePage(
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

class UserHomePage {
  bool isSelected;
  final int id; // Ensure id is of type int
  final String name;
  final List<String> images;

  UserHomePage({
    required this.isSelected,
    required this.id,
    required this.name,
    required this.images,
  });
}
