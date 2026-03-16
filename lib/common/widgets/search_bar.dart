import 'dart:async';
import 'package:flutter/material.dart';
import '../../generated/l10n.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool autoFocus;
  final String? hintText;

  const SearchBar({
    super.key,
    this.controller,
    this.onTap,
    this.enabled = true,
    this.onChanged,
    this.onClear,
    this.autoFocus = false,
    this.hintText,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Timer? _timer;
  int _currentIndex = 0;
  late FocusNode _focusNode;
  bool _hasText = false;

  List<String> get _searchTerms => [
    S.of(context).searchTermMountain,
    S.of(context).searchTermLake,
    S.of(context).searchTermCave,
    S.of(context).searchTermWaterfall,
    // S.of(context).searchTermRiver,
    // S.of(context).searchTermNationalPark,
    // S.of(context).searchTermClub,
    // S.of(context).searchTermTrip,
  ];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Only start animation if not enabled (for explore page)
    if (!widget.enabled) {
      _startAnimation();
    }

    // Set up text controller listener for active mode
    if (widget.controller != null) {
      _hasText = widget.controller!.text.isNotEmpty;
      widget.controller!.addListener(_onTextChanged);
    }

    // Auto focus if requested
    if (widget.autoFocus && widget.enabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  void _onTextChanged() {
    if (widget.controller != null) {
      final hasText = widget.controller!.text.isNotEmpty;
      if (hasText != _hasText) {
        setState(() {
          _hasText = hasText;
        });
      }
    }
  }

  void _startAnimation() {
    _animationController.forward();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _animationController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % _searchTerms.length;
          });
          _animationController.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController.dispose();
    _focusNode.dispose();
    if (widget.controller != null) {
      widget.controller!.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSearchBar();
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: !widget.enabled ? widget.onTap : null,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(Icons.search, color: colorScheme.onSurfaceVariant, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: widget.enabled
                  ? _buildActiveInput(colorScheme)
                  : _buildAnimatedPlaceholder(colorScheme),
            ),
            if (widget.enabled && _hasText && widget.onClear != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  widget.onClear!();
                  setState(() {
                    _hasText = false;
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withAlpha(51),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
            const SizedBox(width: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveInput(ColorScheme colorScheme) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      textAlignVertical: TextAlignVertical.top,
      style: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintStyle: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.only(top: 8, bottom: 12),
      ),
    );
  }

  Widget _buildAnimatedPlaceholder(ColorScheme colorScheme) {
    return Row(
      children: [
        Text(
          S.of(context).searchFind,
          style: TextStyle(
            color: colorScheme.onSurfaceVariant,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        AnimatedBuilder(
          animation: _fadeAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Text(
                _searchTerms[_currentIndex],
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
