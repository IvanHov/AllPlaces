import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import '../utils/localization_helper.dart';
import '../../modules/explore/widgets/save_button_widget.dart';
import 'location_image_widget.dart';

class LocationItemWidget extends StatefulWidget {
  final Location location;
  final VoidCallback? onTap;

  const LocationItemWidget({super.key, required this.location, this.onTap});

  @override
  State<LocationItemWidget> createState() => _LocationItemWidgetState();
}

class _LocationItemWidgetState extends State<LocationItemWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  // Pre-calculated gradient to avoid recreating it on every build
  static const Decoration _gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.transparent,
        Color.fromRGBO(0, 0, 0, 0.1),
        Color.fromRGBO(0, 0, 0, 0.6),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0.4, 0.6, 1.0],
    ),
  );

  // Pre-calculated text style to avoid recreating it
  static const TextStyle _baseTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    shadows: [Shadow(blurRadius: 10.0, offset: Offset(2.0, 2.0))],
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RepaintBoundary(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          elevation: 2,
          child: Stack(
            fit: StackFit.expand,
            children: [
              LocationImageWidget(locationId: widget.location.id),
              const DecoratedBox(decoration: _gradientDecoration),
              _buildInfoPane(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoPane() {
    final languageCode = LocalizationHelper.getCurrentLanguageCode(context);
    final localizedName = widget.location.name.getByLanguage(languageCode);

    return Positioned(
      bottom: 6,
      left: 6,
      right: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _OptimizedText(text: localizedName, style: _baseTextStyle),
          ),
          // const SizedBox(width: 8),
          SaveButtonWidget(locationId: widget.location.id),
        ],
      ),
    );
  }
}

// Optimized text widget that calculates size efficiently
class _OptimizedText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _OptimizedText({required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust maxLines based on screen width to prevent poor wrapping
        final maxLines = constraints.maxWidth < 200 ? 2 : 3;
        final fontSizes = [20.0, 18.0, 16.0, 14.0, 12.0, 10.0, 8.0];

        for (final fontSize in fontSizes) {
          final textStyle = style.copyWith(fontSize: fontSize);
          final textPainter = TextPainter(
            text: TextSpan(text: text, style: textStyle),
            maxLines: maxLines,
            textDirection: TextDirection.ltr,
          );

          textPainter.layout(maxWidth: constraints.maxWidth);

          if (!textPainter.didExceedMaxLines || fontSize == fontSizes.last) {
            return Text(
              text,
              style: textStyle,
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            );
          }
        }

        // Fallback
        return Text(
          text,
          style: style.copyWith(fontSize: 8.0),
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
