part of 'card_widgets.dart';

class BlogCardWidget extends StatefulWidget {
  const BlogCardWidget({
    super.key,
    required this.title,
    this.description,
    this.image,
    this.cardWidgetType = BlogCardWidgetType.contentBL,
    this.isLoading = true,
  });
  final String title;
  final String? description;
  final ImageProvider<Object>? image;
  final BlogCardWidgetType cardWidgetType;
  final bool isLoading;
  @override
  State<BlogCardWidget> createState() => _BlogCardWidgetState();
}

class _BlogCardWidgetState extends State<BlogCardWidget> {
  bool isHovering = false;
  void changeHoverState(bool value) {
    return setState(() => isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    final _contentTextAlign = switch (widget.cardWidgetType) {
      BlogCardWidgetType.contentBL ||
      BlogCardWidgetType.contentTL =>
        TextAlign.left,
      BlogCardWidgetType.contentBR ||
      BlogCardWidgetType.contentTR =>
        TextAlign.right,
      BlogCardWidgetType.contentBC ||
      BlogCardWidgetType.contentTC =>
        TextAlign.center,
    };
    final _columCrossAxisAlignment = switch (widget.cardWidgetType) {
      BlogCardWidgetType.contentBC ||
      BlogCardWidgetType.contentTC =>
        CrossAxisAlignment.center,
      BlogCardWidgetType.contentBR ||
      BlogCardWidgetType.contentTR =>
        CrossAxisAlignment.end,
      BlogCardWidgetType.contentBL ||
      BlogCardWidgetType.contentTL =>
        CrossAxisAlignment.start,
    };

    final _shimmerLoadingColor =
        _isDark ? AcnooAppColors.kDark3 : AcnooAppColors.kNeutral200;

    final _cardContents = [
      // Image Container
      if (widget.isLoading)
        ShimmerPlaceholder(
          height: 300,
          width: double.maxFinite,
          color: _shimmerLoadingColor,
        )
      else
        Container(
          height: 300,
          decoration: BoxDecoration(
            image: widget.image == null
                ? null
                : DecorationImage(image: widget.image!, fit: BoxFit.cover),
          ),
        ),

      // Text Contents
      Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: 20,
          vertical: 24,
        ),
        child: Column(
          crossAxisAlignment: _columCrossAxisAlignment,
          children: [
            // Title Text
            if (widget.isLoading)
              ShimmerPlaceholder(
                color: _shimmerLoadingColor,
              )
            else
              SelectableText(
                widget.title,
                textAlign: _contentTextAlign,
                style: _theme.textTheme.headlineLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 8),

            // Description
            if (widget.isLoading)
              Column(
                crossAxisAlignment: _columCrossAxisAlignment,
                children: [
                  ShimmerPlaceholder(
                    color: _shimmerLoadingColor,
                    width: double.maxFinite,
                  ),
                  ShimmerPlaceholder(
                    color: _shimmerLoadingColor,
                    width: 300,
                  ),
                  ShimmerPlaceholder(
                    color: _shimmerLoadingColor,
                    width: double.maxFinite,
                  ),
                  ShimmerPlaceholder(
                    color: _shimmerLoadingColor,
                    width: double.maxFinite,
                  ),
                ]
                    .map((e) => Padding(
                        padding:
                            const EdgeInsetsDirectional.symmetric(vertical: 2),
                        child: e))
                    .toList(),
              )
            else
              SelectableText(
                widget.description ?? 'No description provided',
                textAlign: _contentTextAlign,
                style: _theme.textTheme.bodyLarge,
              ),
            const SizedBox(height: 16),

            if (widget.isLoading)
              ShimmerPlaceholder(
                height: 48,
                decoration: BoxDecoration(
                  color: _shimmerLoadingColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              )
            else
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: !isHovering ? null : _theme.primaryColor,
                  foregroundColor: isHovering
                      ? _theme.colorScheme.onPrimary
                      : _theme.colorScheme.onTertiaryContainer,
                  side: isHovering
                      ? BorderSide.none
                      : BorderSide(
                          color: _theme.colorScheme.outline,
                        ),
                ),
                // child:  Text("Read More"),
                child: Text(lang.readMore),
              )
          ],
        ),
      ),
    ];

    return MouseRegion(
      onEnter: (event) => changeHoverState(true),
      onExit: (event) => changeHoverState(false),
      cursor: SystemMouseCursors.click,
      child: Material(
        color: _theme.colorScheme.primaryContainer,
        elevation: isHovering ? 4.75 : 0,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: _columCrossAxisAlignment,
          children: switch (widget.cardWidgetType) {
            BlogCardWidgetType.contentTC ||
            BlogCardWidgetType.contentTL ||
            BlogCardWidgetType.contentTR =>
              _cardContents.reversed.toList(),
            _ => _cardContents,
          },
        ),
      ),
    );
  }
}

enum BlogCardWidgetType {
  /// Content Bottom Left
  contentBL,

  /// Content Bottom Right
  contentBR,

  /// Content Bottom Center
  contentBC,

  /// Content Top Left
  contentTL,

  /// Content Top Right
  contentTR,

  /// Content Top Center
  contentTC,
}
