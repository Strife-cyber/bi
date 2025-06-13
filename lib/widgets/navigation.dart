import 'package:flutter/material.dart';

class Navigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChanged;
  final Color? accentColor;
  final Color? backgroundColor;
  final double height;
  final bool showLabels;
  final bool showIndicator;

  const Navigation({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    this.accentColor,
    this.backgroundColor,
    this.height = 64.0,
    this.showLabels = true,
    this.showIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    final accent = accentColor ?? const Color(0xFF10B981);
    final bgColor = backgroundColor ?? const Color(0xFF0F172A);
    
    final navItems = [
      NavItem(Icons.dashboard_rounded, 'Dashboard'),
      NavItem(Icons.search_rounded, 'Inspections'),
      NavItem(Icons.assignment_rounded, 'Rapports'),
      NavItem(Icons.verified_rounded, 'Conformité'),
    ];

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top indicator line
          if (showIndicator) _buildIndicator(navItems.length, accent),
          
          // Main navigation row
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (index) {
                return _buildNavItem(
                  context,
                  navItems[index].icon,
                  navItems[index].label,
                  index,
                  accent,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int itemCount, Color accentColor) {
    return SizedBox(
      height: 2,
      child: Row(
        children: List.generate(itemCount, (index) {
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: currentIndex == index 
                    ? accentColor 
                    : Colors.transparent,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    int index,
    Color accentColor,
  ) {
    final isActive = currentIndex == index;
    final textTheme = Theme.of(context).textTheme;
    
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTabChanged(index),
          splashColor: accentColor.withValues(alpha: 0.1),
          highlightColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with animated container
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isActive 
                      ? accentColor.withValues(alpha: 0.15) 
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: isActive 
                      ? accentColor 
                      : Colors.white.withValues(alpha: 0.6),
                ),
              ),
              
              // Label
              if (showLabels) ...[
                const SizedBox(height: 4),
                Text(
                  label,
                  style: textTheme.labelSmall?.copyWith(
                    color: isActive 
                        ? accentColor 
                        : Colors.white.withValues(alpha: 0.6),
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  NavItem(this.icon, this.label);
}

// Example Usage
class FooterNavExample extends StatefulWidget {
  const FooterNavExample({super.key});

  @override
  State<FooterNavExample> createState() => _FooterNavExampleState();
}

class _FooterNavExampleState extends State<FooterNavExample> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text('Dashboard', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Inspections', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Rapports', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Conformité', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Navigation(
        currentIndex: _currentIndex,
        onTabChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // Optional customization
        // accentColor: const Color(0xFF10B981),
        // backgroundColor: const Color(0xFF0F172A),
        // height: 70,
        // showLabels: true,
        // showIndicator: true,
      ),
    );
  }
}

// Enhanced version with animated navigation
class AnimatedFooterNav extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabChanged;
  final Color? accentColor;
  final Color? backgroundColor;
  final double height;

  const AnimatedFooterNav({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
    this.accentColor,
    this.backgroundColor,
    this.height = 70.0,
  });

  @override
  State<AnimatedFooterNav> createState() => _AnimatedFooterNavState();
}

class _AnimatedFooterNavState extends State<AnimatedFooterNav> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _controller.forward();
  }

  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigation(
      currentIndex: widget.currentIndex,
      onTabChanged: widget.onTabChanged,
      accentColor: widget.accentColor,
      backgroundColor: widget.backgroundColor,
      height: widget.height,
    );
  }
}