import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/widgets/main_button_widget.dart';
import '../../../generated/l10n.dart';
import '../bloc/auth_bloc.dart';

class NameAuthWidget extends StatefulWidget {
  final VoidCallback? onSuccess;

  const NameAuthWidget({super.key, this.onSuccess});

  @override
  State<NameAuthWidget> createState() => _NameAuthWidgetState();
}

class _NameAuthWidgetState extends State<NameAuthWidget> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocus = FocusNode();
  String? _error;

  @override
  void dispose() {
    _nameFocus.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _nameFocus.requestFocus();
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
        if (state.step == AuthStep.success) {
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
              S.of(context).yourName,
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
            Form(key: _formKey, child: _buildNameStep()),
            const SizedBox(height: 16),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return MainButtonWidget(
                  text: S.of(context).confirm,
                  onPressed: state.isLoading ? null : _submitName,
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

  void _submitName() {
    if (_formKey.currentState?.validate() != true) return;
    context.read<AuthBloc>().add(AuthNameSubmitted(_nameController.text));
  }

  Widget _buildNameStep() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).enterNameDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          focusNode: _nameFocus,
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            hintText: S.of(context).name,
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
          validator: (v) => (v == null || v.trim().length < 2)
              ? S.of(context).enterYourName
              : null,
          onFieldSubmitted: (_) => _submitName(),
        ),
        const SizedBox(height: 8),
        Text(
          S.of(context).useRealName,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
