import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship/pages/auth.dart';
import 'package:internship/pages/dashboard.dart';
import 'package:internship/pages/inspections.dart';
import 'package:internship/pages/poilicies.dart';
import 'package:internship/pages/reports.dart';
import 'package:internship/services/auth_service.dart';
import 'package:internship/widgets/navigation.dart';
import 'package:internship/widgets/sidebar.dart';
import 'package:internship/widgets/header.dart';

// AppScaffold: A standard component with a full-screen sidebar and bottom navigation
class AppScaffold extends ConsumerStatefulWidget {
  final Widget? content;
  final int? page;

  const AppScaffold({super.key, this.content, this.page});

  @override
  ConsumerState<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends ConsumerState<AppScaffold> {
  bool _isSidebarOpen = false;
  int _currentIndex = 0;
  bool switchedAfterContent = false;

  // List of pages corresponding to navigation items
  static final List<Widget> _pages = [
    const Dashboard(),
    const Inspections(),
    const AnalysisResultsPage(),
    const ConstructionRegulationsPage(),
  ];

  // Routes corresponding to navigation items (for sidebar navigation)
  static const List<String?> _routes = [
    '/dashboard',
    '/inspections',
    '/reports',
    '/compliance',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.page != null) {
      _currentIndex = widget.page!;
    }
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
      if (widget.content != null || widget.page != null) {
        switchedAfterContent = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Scaffold
            Scaffold(
              appBar: Header(
                appName: 'Batiment Intelligent',
                onMenuPressed: _toggleSidebar
              ),
              body: SafeArea(child: widget.content != null && !switchedAfterContent ? widget.content! : (widget.page != null && !switchedAfterContent ? _pages[widget.page!] : _pages[_currentIndex])),
              bottomNavigationBar: Navigation(
                currentIndex: _currentIndex,
                onTabChanged: _onTabChanged,
                accentColor: const Color(0xFF10B981),
                backgroundColor: const Color(0xFF0F172A),
                height: 64.0,
                showLabels: true,
                showIndicator: true,
              ),
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
                            // Update currentIndex based on route
                            final index = _routes.indexOf(route);
                            if (index != -1) {
                              setState(() {
                                _currentIndex = index;
                              });
                            }
                            Navigator.pushNamed(context, route);
                          }
                        },
                        onLogout: () {
                          _toggleSidebar();
                          authService.signOut();
                          setState(() {
                            _currentIndex = 0; // Reset to initial tab
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AuthWrapper()));
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}