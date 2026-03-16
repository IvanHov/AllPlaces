import 'package:flutter/material.dart';
import 'package:domain/domain.dart';
import 'package:get_it/get_it.dart';
import 'dart:async';

import '../../../common/theme/app_colors.dart';

class SaveButtonWidget extends StatefulWidget {
  final String locationId;
  final ValueChanged<bool>? onSaveChanged;
  final double? size;
  final double? iconSize;

  const SaveButtonWidget({
    super.key,
    required this.locationId,
    this.onSaveChanged,
    this.size,
    this.iconSize,
  });

  @override
  State<SaveButtonWidget> createState() => _SaveButtonWidgetState();
}

class _SaveButtonWidgetState extends State<SaveButtonWidget> {
  late bool isSaved;
  bool _isPressed = false;
  SavingLocationsUseCase? _savedLocationsUseCase;
  StreamSubscription<List<String>>? _savedLocationsSubscription;

  @override
  void initState() {
    super.initState();
    _savedLocationsUseCase = GetIt.instance<SavingLocationsUseCase>();
    isSaved = false;
    _loadSavedState();
    _subscribeToSavedLocations();
  }

  @override
  void dispose() {
    _savedLocationsSubscription?.cancel();
    super.dispose();
  }

  void _subscribeToSavedLocations() {
    if (_savedLocationsUseCase != null) {
      _savedLocationsSubscription = _savedLocationsUseCase!
          .watchSavedLocationIds()
          .listen((savedLocationIds) {
            if (mounted) {
              setState(() {
                isSaved = savedLocationIds.contains(widget.locationId);
              });
            }
          });
    }
  }

  Future<void> _loadSavedState() async {
    if (_savedLocationsUseCase != null) {
      final saved = await _savedLocationsUseCase!.isSaved(widget.locationId);
      if (mounted) {
        setState(() {
          isSaved = saved;
        });
      }
    }
  }

  Future<void> _toggleSave() async {
    if (_savedLocationsUseCase != null) {
      await _savedLocationsUseCase!.toggleSaved(widget.locationId);
      // Состояние обновится автоматически через stream subscription
      widget.onSaveChanged?.call(
        !isSaved,
      ); // Вызываем callback с новым значением
    }
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _toggleSave();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = widget.size ?? 28;
    final buttonIconSize = widget.iconSize ?? 16;

    return AnimatedScale(
      scale: _isPressed ? 0.9 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Container(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(
                  255,
                  255,
                  255,
                  255,
                ).withValues(alpha: 0.5),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: Icon(
              Icons.bookmark,
              key: ValueKey(isSaved),
              color: isSaved
                  ? AppColors.primaryLight
                  : const Color.fromARGB(255, 255, 254, 254),
              size: buttonIconSize,
            ),
          ),
        ),
      ),
    );
  }
}
