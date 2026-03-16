import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../../common/widgets/main_button_widget.dart';
import '../../../common/widgets/rounded_button_widget.dart';
import '../../../generated/l10n.dart';
import '../bloc/auth_bloc.dart';

class OtpAuthWidget extends StatefulWidget {
  final String phoneNumber;
  final VoidCallback? onSuccess;
  final VoidCallback? onBack;

  const OtpAuthWidget({
    super.key,
    required this.phoneNumber,
    this.onSuccess,
    this.onBack,
  });

  @override
  State<OtpAuthWidget> createState() => _OtpAuthWidgetState();
}

class _OtpAuthWidgetState extends State<OtpAuthWidget> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _otpFocus = FocusNode();
  String? _error;
  Timer? _timer;
  int _remainingTime = 120;
  bool _canResend = false;

  @override
  void dispose() {
    _timer?.cancel();
    _otpFocus.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _otpFocus.requestFocus();
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
        if (state.step == AuthStep.name || state.step == AuthStep.success) {
          widget.onSuccess?.call();
        } else if (state.step == AuthStep.phone) {
          widget.onBack?.call();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: RoundedButtonWidget(
                icon: Icons.arrow_back,
                onTap: () {
                  context.read<AuthBloc>().add(const AuthBackPressed());
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              S.of(context).enterCode,
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
            Form(key: _formKey, child: _buildOtpStep()),
            const SizedBox(height: 16),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return MainButtonWidget(
                  text: S.of(context).confirm,
                  onPressed: state.isLoading ? null : _verifyOtp,
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

  void _verifyOtp() {
    if (_formKey.currentState?.validate() != true) return;
    context.read<AuthBloc>().add(AuthOtpSubmitted(_otpController.text));
  }

  void _requestOtp() {
    context.read<AuthBloc>().add(AuthPhoneSubmitted(widget.phoneNumber));
  }

  void _startTimer() {
    _canResend = false;
    _remainingTime = 120;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_remainingTime > 0) {
            _remainingTime--;
          } else {
            _canResend = true;
            _timer?.cancel();
          }
        });
      }
    });
  }

  void _resendCode() {
    if (_canResend) {
      _requestOtp();
      _startTimer();
    }
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildOtpStep() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            children: [
              TextSpan(text: S.of(context).sentSMSCode),
              TextSpan(
                text: widget.phoneNumber,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 4,
          focusNode: _otpFocus,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          decoration: InputDecoration(
            hintText: S.of(context).code,
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
            counterText: '',
          ),
          validator: (value) {
            if ((value ?? '').length != 4) return S.of(context).enterDigits;
            return null;
          },
          onFieldSubmitted: (_) => _verifyOtp(),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: _canResend ? _resendCode : null,
            child: Text(
              _canResend
                  ? S.of(context).didntReceiveCode
                  : '${S.of(context).didntReceiveCode} ${_formatTime(_remainingTime)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _canResend
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
