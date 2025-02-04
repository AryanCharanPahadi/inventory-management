import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../component/elevated_button.dart';
import '../../../generated/l10n.dart' as l;
import '../../core/theme/_app_colors.dart';
import '../../widgets/avatars/_avatar_widget.dart';
import '../../widgets/shadow_container/_shadow_container.dart';
import '../api_service/api_service.dart';
import '../dragndrop_page/dragndrop_view.dart';

class JewelleryBannerTable extends StatefulWidget {
  const JewelleryBannerTable({super.key});

  @override
  State<JewelleryBannerTable> createState() => _JewelleryBannerTableState();
}

class _JewelleryBannerTableState extends State<JewelleryBannerTable> {
  List<String> _bannerImages = [];
  bool _isLoading = true;
  bool _selectAll = false;
  List<UserBanner> _users = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchBannerImages();
  }

  Future<void> _fetchBannerImages() async {
    try {
      final users = await ApiService.fetchJewellaryBannerImages();
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

  void _editUserProduct(UserBanner userBanner) {
    // Navigate to the edit route and pass the product details
    context.go(
      '/tables/edit-product-Banner',
      extra: userBanner, // Pass the product details as an extra
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
                                user.name,
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
                                  await ApiService.deleteProductBanner(
                                      context, user.id);
                                  await _fetchBannerImages();
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

class UserBanner {
  bool isSelected;
  final int id; // Ensure id is of type int
  final String name;
  final List<String> images;

  UserBanner({
    required this.isSelected,
    required this.id,
    required this.name,
    required this.images,
  });
}
