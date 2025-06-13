import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship/widgets/sidebar.dart';
import 'package:internship/widgets/header.dart';

// GlassmorphicScaffold: A standard component with a full-screen sidebar
class GlassmorphicScaffold extends ConsumerStatefulWidget {
  final Widget body;

  const GlassmorphicScaffold({
    super.key,
    required this.body,
  });

  @override
  ConsumerState<GlassmorphicScaffold> createState() => _GlassmorphicScaffoldState();
}

class _GlassmorphicScaffoldState extends ConsumerState<GlassmorphicScaffold> {
  bool _isSidebarOpen = false;

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Main Scaffold
        Scaffold(
          appBar: Header(
            appName: 'Batiment Intelligent',
            onMenuPressed: _toggleSidebar,
          ),
          body: SafeArea(child: widget.body),
        ),
        // Sidebar overlay
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: _isSidebarOpen ? 0 : -screenWidth,
          top: 0,
          bottom: 0,
          width: screenWidth,
          child: GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! < 0) {
                _toggleSidebar();
              }
            },
            child: ClipRRect(
              borderRadius: _isSidebarOpen
                  ? BorderRadius.zero
                  : const BorderRadius.horizontal(right: Radius.circular(20)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    border: Border(
                      right: BorderSide(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Sidebar(
                    onToggleSidebar: _toggleSidebar,
                    onNavigate: (route) {
                      _toggleSidebar();
                      if (route != null) {
                        Navigator.pushNamed(context, route);
                      }
                    },
                    onLogout: () {
                      _toggleSidebar();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
