// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import 'package:acnoo_flutter_admin_panel/app/pages/users_page/user_grid/demo_users.dart';
import '../../../widgets/user_grid_widget/user_grid_widget.dart';

class UsersGridView extends StatelessWidget {
  const UsersGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(8),
            innerSpacing: 8,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(12),
            innerSpacing: 12,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    return Scaffold(
      body: Padding(
        padding: _sizeInfo.padding / 2.5,
        child: SingleChildScrollView(
          child: ResponsiveGridRow(
            children: demoUsers
                .asMap()
                .entries
                .map(
                  (e) => ResponsiveGridCol(
                    lg: 3,
                    md: 6,
                    xs: 12,
                    child: FutureBuilder<String?>(
                      future: Future.delayed(
                        const Duration(milliseconds: 2500),
                        () => 'completed',
                      ),
                      builder: (context, snapshot) => Padding(
                        padding: _sizeInfo.padding / 2.5,
                        child: UserGridWidget(
                          imagePath: e.value.imagePath,
                          name: e.value.name,
                          designation: e.value.designation,
                          followers: e.value.followers,
                          following: e.value.following,
                          orders: e.value.orders,
                          products: e.value.products,
                          totalRevenue: e.value.totalRevenue,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;

  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}
