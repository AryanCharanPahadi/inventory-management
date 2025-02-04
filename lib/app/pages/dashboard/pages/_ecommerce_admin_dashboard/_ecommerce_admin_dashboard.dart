// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart';
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/theme/theme.dart';
import '../../../../widgets/widgets.dart';
import '../../../api_service/api_service.dart';
import 'components/_components.dart' as comp;

class ECommerceAdminDashboardView extends StatefulWidget {
  const ECommerceAdminDashboardView({super.key});

  @override
  State<ECommerceAdminDashboardView> createState() =>
      _ECommerceAdminDashboardViewState();
}

class _ECommerceAdminDashboardViewState
    extends State<ECommerceAdminDashboardView> {
  int totalProducts = 0; // Variable to store the fetched length

  @override
  void initState() {
    super.initState();
    _fetchHomePage();
  }

  Future<void> _fetchHomePage() async {
    try {
      final users = await ApiService.fetchJewellaryDetails();
      setState(() {
        totalProducts = users.length;
      });
      print(
          'Fetched product details length: ${users.length}'); // Print the length of the fetched data
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    final _mqSize = MediaQuery.sizeOf(context);
    final _lang = l.S.of(context);

    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      lg: 24,
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsetsDirectional.all(_padding / 2.5),
        child: Column(
          children: [
            // Overviews
            ResponsiveGridRow(
              rowSegments: 100,
              children: List.generate(
                _overviewItems(totalProducts).length,
                (index) {
                  final _data = _overviewItems(totalProducts)[index];

                  return ResponsiveGridCol(
                    lg: _mqSize.width < 1400 ? 33 : 20,
                    md: _mqSize.width < 768 ? 50 : 33,
                    xs: 100,
                    child: Padding(
                      padding: EdgeInsets.all(_padding / 2.5),
                      child: OverviewTileWidget(
                        value: _data.$1,
                        title: _data.$2,
                        imagePath: _data.$3,
                        iconSize: 60,
                        valueStyle: _theme.textTheme.titleLarge?.copyWith(
                          color: _isDark ? Colors.white : null,
                        ),
                        titleStyle: _theme.textTheme.bodyLarge?.copyWith(
                          color: _isDark ? Colors.white : null,
                        ),
                        iconAlignment: IconAlignment.end,
                        tileColor: _data.$4.withOpacity(_isDark ? 0.2 : 1),
                        iconRadius: BorderRadius.zero,
                        iconBackgroundColor: Colors.transparent,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Other Contents
            ResponsiveGridRow(
              children: [
                // Left Side Contents
                ResponsiveGridCol(
                  lg: _mqSize.width < 1700 ? 7 : 8,
                  child: ResponsiveGridRow(
                    children: [
                      // Order Status
                      ResponsiveGridCol(
                        child: ShadowContainer(
                          margin: EdgeInsetsDirectional.all(_padding / 2.5),
                          contentPadding:
                              EdgeInsetsDirectional.all(_padding / 2.5),
                          // headerText: 'Order Status',
                          headerText: _lang.orderStatus,
                          trailing: const FilterDropdownButton(),
                          child: ResponsiveGridRow(
                            children: List.generate(
                              _orderStatus.length,
                              (index) {
                                final _data = _orderStatus[index];
                                return ResponsiveGridCol(
                                  lg: _mqSize.width < 1700 ? 6 : 4,
                                  md: _mqSize.width < 768 ? 6 : 4,
                                  xs: _mqSize.width < 480 ? 12 : 6,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.all(
                                      _padding / 2.5,
                                    ),
                                    child: OverviewTileWidget(
                                      value: _data.$1,
                                      title: _data.$2,
                                      imagePath: _data.$3,
                                      iconBackgroundColor: _data.$4,
                                      tileColor: _data.$5.withOpacity(
                                        _isDark ? 0.20 : 1,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<(int, String, String, Color)> _overviewItems(int productCount) => [
      (
        productCount,
        l.S.current.totalProducts,
        //"Total Products",
        "assets/images/widget_images/dashboard_overview_icon/total_products.svg",
        const Color(0xffddecff),
      ),
      (
        8,
        //"Total Delivery Boy",
        l.S.current.totalDeliveryBoy,
        "assets/images/widget_images/dashboard_overview_icon/total_delivery_boy.svg",
        const Color(0xffFFE5D9),
      ),
      (
        500,
        // "Total Revenue",
        l.S.current.totalRevenue,
        "assets/images/widget_images/dashboard_overview_icon/total_revenue.svg",
        const Color(0xffCFFEEC),
      ),
    ];

List<(int, String, String, Color, Color)> get _orderStatus => [
      (
        10,
        //"Pending",
        l.S.current.pending,
        "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/pending_orders.svg",
        const Color(0xffFF6921),
        const Color(0xffFFF4EF),
      ),
      (
        8,
        // "Processing",
        l.S.current.processing,
        "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/processing_orders.svg",
        const Color(0xff4429FF),
        const Color(0xffEEEDFF),
      ),
      (
        6,
        //"Cancelled",
        l.S.current.cancelled,
        "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/cancelled_orders.svg",
        const Color(0xffFA0808),
        const Color(0xffFFF0F0),
      ),
      (
        15,
        //"Shipped",
        l.S.current.shipped,
        "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/shipped_orders.svg",
        const Color(0xff851EEC),
        const Color(0xffF5EDFD),
      ),
      (
        12,
        //"Out of Delivery",
        l.S.current.outOfDelivery,
        "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/out_of_delivery_orders.svg",
        const Color(0xffE300CD),
        const Color(0xffFFEEFD),
      ),
      (
        25,
        l.S.current.delivered,
        //"Delivered",
        "assets/images/widget_images/dashboard_overview_icon/ecommerce_admin_icons/delivered_orders.svg",
        const Color(0xff00B293),
        const Color(0xffDCFBF5),
      ),
    ];
