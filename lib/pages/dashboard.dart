import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship/models/project.dart';
import 'package:internship/services/auth_service.dart';
import 'package:internship/services/notification_service.dart';
import 'package:internship/services/project_service.dart';
import 'package:internship/utilities/date.dart';
import 'package:internship/widgets/app_scaffold.dart';
import 'package:timeago/timeago.dart' as timeago;

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  final notifications = [];
  final List<Project> projects = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final projectService = ref.read(projectServiceProvider);
    final notificationService = ref.read(notificationServiceProvider);

    fetchNotifications(notificationService);
    fetchProjects(projectService);
  }

  void fetchNotifications(NotificationService notificationService) async {
    final notifs = await notificationService.fetchNotifications();
    setState(() {
      notifications.addAll(notifs);
    });
  }

  void fetchProjects(ProjectService projectService) async {
    try {
      final pjects = await projectService.getProjects();
      final analysisFutures = pjects.map((p) => 
          projectService.getAnalysisForProject(p.id)
      );

      final analyses = await Future.wait(analysisFutures);

      setState(() {
        projects.addAll(pjects.asMap().entries.map((entry) {
          return entry.value.copyWith(analysis: analyses[entry.key]);
        }).toList());
      });
    } catch (e) {
      // Add error handling/logging
      throw Exception('Failed to load projects: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildWelcomeSection(authService),
            ),
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            systemOverlayStyle: SystemUiOverlayStyle.light,
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildStatsGrid(),
                const SizedBox(height: 24),
                _buildQuickActions(),
                const SizedBox(height: 24),
                _buildAIInsights(),
                const SizedBox(height: 24),
                _buildActiveProjects(),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      )
    );
  }

  Widget _buildWelcomeSection(AuthService authService) {
    final user = authService.currentUser;
    final alertsCount = notifications.length;
    final inspectionsCount = projects.fold(0, (sum, p) => sum + p.analysis.length);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade400.withValues(alpha: 0.6),
            Colors.teal.shade800.withValues(alpha: 0.8)
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bonjour, ${user?.displayName ?? user?.email}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Vous avez $alertsCount nouvelles alertes et $inspectionsCount inspections aujourd\'hui.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    final stats = [
      {'title': 'Inspections', 'value': (projects.fold(0, (sum, p) => sum + p.analysis.length)).toString(), 'change': '+3', 'icon': Icons.search, 'color': Colors.blueAccent},
      {'title': 'Alertes', 'value': notifications.length.toString(), 'change': '2 critiques', 'icon': Icons.warning, 'color': Colors.orange},
      {'title': 'Conformité', 'value': '87%', 'change': '+5%', 'icon': Icons.verified, 'color': Colors.green},
      {'title': 'Drones', 'value': '3/5', 'change': 'En mission', 'icon': Icons.flaky, 'color': Colors.purple},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return _buildStatCard(
          title: stat['title'] as String,
          value: stat['value'] as String,
          change: stat['change'] as String,
          icon: stat['icon'] as IconData,
          color: stat['color'] as Color,
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    change,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'title': 'Nouvelle Inspection', 'icon': Icons.search, 'color': Colors.tealAccent, 'onClicked': () => Navigator.push(context, MaterialPageRoute(builder: (context) => AppScaffold(page: 1)))},
      {'title': 'Conformite', 'icon': Icons.article, 'color': Colors.blueAccent, 'onClicked': () => Navigator.push(context, MaterialPageRoute(builder: (context) => AppScaffold(page: 3)))},
      {'title': 'Rapports', 'icon': Icons.psychology, 'color': Colors.purpleAccent, 'onClicked': () => Navigator.push(context, MaterialPageRoute(builder: (context) => AppScaffold(page: 2)))},
      {'title': 'Capteurs', 'icon': Icons.sensors, 'color': Colors.orange, 'onClicked': () => {}},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actions rapides',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return _buildActionCard(
              title: action['title'] as String,
              icon: action['icon'] as IconData,
              color: action['color'] as Color,
              onClicked: action['onClicked'] as Function
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required Function onClicked
  }) {
    return Material(
      color: const Color(0xFF1E1E1E),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onClicked(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIInsights() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.shade800.withValues(alpha: 0.8),
            Colors.blue.shade900.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Analyse Prédictive',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Nouveau',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Grâce à notre intelligence artificielle de dernière génération, nous identifions les zones à risque avant qu’elles ne deviennent des tragédies. À New Bell, 3 bâtiments à haut risque ont été signalés. Il est temps que la technologie serve la sécurité de tous",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInsightMetric('94.2%', 'Précision'),
                _buildInsightMetric('87%', 'Confiance'),
                _buildInsightMetric('Élevé', 'Risque'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightMetric(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveProjects() {
    final random = Random();

    timeago.setLocaleMessages('fr', timeago.FrMessages());
    final activeProjects = projects.map((p) => {
      'name': p.name,
      'details': p.description,
      'progress': random.nextDouble(),
      'color': getRandomColor(),
      'daysLeft': timeago.format(p.createdAt.toDate(), locale: 'fr')
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Projets actifs',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activeProjects.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final project = activeProjects[index];
            return _buildProjectCard(
              name: project['name'] as String,
              details: project['details'] as String,
              progress: project['progress'] as double,
              color: project['color'] as Color,
              daysLeft: project['daysLeft'] as String,
            );
          },
        ),
      ],
    );
  }

  Widget _buildProjectCard({
    required String name,
    required String details,
    required double progress,
    required Color color,
    required String daysLeft,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.folder_open,
                    color: color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        details,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade800,
                    color: color,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              daysLeft,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}