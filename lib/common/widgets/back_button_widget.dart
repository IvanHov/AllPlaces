import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'rounded_button_widget.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 12.0),
        RoundedButtonWidget(
          icon: Icons.arrow_back_ios_new,
          onTap: () {
            HapticFeedback.lightImpact();
            context.pop();
          },
        ),
      ],
    );
  }
}
