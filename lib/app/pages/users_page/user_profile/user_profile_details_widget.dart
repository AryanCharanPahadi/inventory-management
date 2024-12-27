// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../../core/helpers/fuctions/_get_image.dart';

class UserProfileDetailsWidget extends StatelessWidget {
  const UserProfileDetailsWidget({
    super.key,
    required double padding,
    required this.theme,
    required this.textTheme,
  }) : _padding = padding;

  final double _padding;
  final ThemeData theme;
  final TextTheme textTheme;

  Widget _buildProfileDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.all(_padding),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: textTheme.bodyLarge,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Text(
                  ':',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 178,
          width: MediaQuery.of(context).size.width,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20.0),
              topLeft: Radius.circular(20.0),
            ),
          ),
          child: getImageType(_userProfile.$1,
              fit: BoxFit.cover, alignment: Alignment.bottomCenter),
        ),
        const SizedBox(height: 70),
        Padding(
          padding: EdgeInsets.all(_padding),
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: theme.colorScheme.outline,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileDetailRow('${lang.fullName}', 'Sahidul Islam'),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow(lang.email, 'shaidulislma@gmail.com'),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow(lang.phoneNumber, '12345878732'),
                Divider(
                  color: theme.colorScheme.outline,
                  height: 0.0,
                ),
                _buildProfileDetailRow(lang.registrationDate, '23 Oct, 2024'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

const (String,) _userProfile =
    ('assets/images/static_images/background_images/background_image_08.png',);
