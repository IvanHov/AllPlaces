import 'dart:async';
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';

class ExploreHeader extends StatefulWidget {
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final bool enabled;
  final int selectedTab;
  final ValueChanged<int?> onTabChanged;

  const ExploreHeader({
    super.key,
    this.controller,
    this.onTap,
    this.enabled = true,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  State<ExploreHeader> createState() => _ExploreHeaderState();
}

class _ExploreHeaderState extends State<ExploreHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Timer? _timer;
  int _currentIndex = 0;

  List<String> get _searchTerms => [
    S.of(context).mountain,
    S.of(context).lake,
    S.of(context).cave,
    S.of(context).waterfall,
    S.of(context).club,
    S.of(context).trip,
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _startAnimation();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).toInt()),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: [_buildSearchBar(), _buildTabBar()]),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: !widget.enabled ? widget.onTap : null,
      child: Container(
        height: 44,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255 * 0.05).toInt()),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(Icons.search, color: Colors.grey[600], size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Text(
                    S.of(context).find,
                    style: const TextStyle(
                      color: Colors.grey,
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
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTab(
            icon: Icons.terrain,
            text: S.of(context).places,
            isSelected: widget.selectedTab == 0,
            onTap: () => widget.onTabChanged(0),
          ),
          _buildTab(
            icon: Icons.hiking,
            text: S.of(context).trips,
            isSelected: widget.selectedTab == 1,
            onTap: () => widget.onTabChanged(1),
          ),
          _buildTab(
            icon: Icons.campaign,
            text: S.of(context).clubs,
            isSelected: widget.selectedTab == 2,
            onTap: () => widget.onTabChanged(2),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.green : Colors.grey[600],
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.green : Colors.grey[600],
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
