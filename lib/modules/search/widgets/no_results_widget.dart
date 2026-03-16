import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';
import '../../../common/widgets/main_button_widget.dart';

class NoResultsWidget extends StatelessWidget {
  final String query;
  final VoidCallback? onSubmitRequest;

  const NoResultsWidget({super.key, required this.query, this.onSubmitRequest});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff000000).withAlpha(20),
                spreadRadius: 1,
                blurRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).noResultsTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Text(
                S.of(context).noResultsFor(query),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 15),
              MainButtonWidget(
                text: S.of(context).submitRequest,
                onPressed:
                    onSubmitRequest ??
                    () {
                      // Handle submit request
                    },
                height: 40,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
