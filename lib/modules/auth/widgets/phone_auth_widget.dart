import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/widgets/main_button_widget.dart';
import '../../../common/widgets/policy_modal.dart';
import '../../../common/utils/phone_formatter.dart';
import '../../../generated/l10n.dart';
import '../bloc/auth_bloc.dart';

class PhoneAuthWidget extends StatefulWidget {
  final VoidCallback? onSuccess;

  const PhoneAuthWidget({super.key, this.onSuccess});

  @override
  State<PhoneAuthWidget> createState() => _PhoneAuthWidgetState();
}

class _PhoneAuthWidgetState extends State<PhoneAuthWidget> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _phoneFocus = FocusNode();
  String? _error;

  @override
  void dispose() {
    _phoneFocus.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _phoneFocus.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) =>
          prev.step != curr.step || prev.error != curr.error,
      listener: (context, state) {
        setState(() {
          _error = state.error;
        });
        if (state.step == AuthStep.otp) {
          widget.onSuccess?.call();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Text(
              S.of(context).phoneNumber,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            Form(key: _formKey, child: _buildPhoneStep()),
            const SizedBox(height: 12),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    S.of(context).byContinuing,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => PolicyModal.show(context),
                    child: Text(S.of(context).dataProcessingPolicy),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return MainButtonWidget(
                  text: S.of(context).sendCode,
                  onPressed: state.isLoading ? null : _requestOtp,
                  isLoading: state.isLoading,
                  height: 52,
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _requestOtp() {
    if (_formKey.currentState?.validate() != true) return;
    setState(() {
      _error = null;
    });
    context.read<AuthBloc>().add(AuthPhoneSubmitted(_phoneController.text));
  }

  Widget _buildPhoneStep() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).enterPhoneNumber,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          focusNode: _phoneFocus,
          autofocus: true,
          inputFormatters: const [Phone998Formatter()],
          decoration: InputDecoration(
            hintText: '+998',
            filled: true,
            fillColor: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(color: Colors.green, width: 2),
            ),
            border: border,
          ),
          validator: (value) {
            final v = value?.trim() ?? '';
            if (!v.startsWith('+998')) return S.of(context).phoneMustStartWith;
            final digits = v.replaceAll(RegExp(r'\D'), '');
            if (digits.length != 12) {
              return S.of(context).enterFullNumber;
            }
            return null;
          },
        ),
      ],
    );
  }
}
