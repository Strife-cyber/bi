import 'dart:io';

import 'package:internship/pages/media_upload.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:internship/models/project.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship/services/project_service.dart';

class ProjectDetailsPage extends ConsumerStatefulWidget {
  final String projectId;

  const ProjectDetailsPage({super.key, required this.projectId});

  @override
  ConsumerState<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends ConsumerState<ProjectDetailsPage> with SingleTickerProviderStateMixin {
  Project? _project;
  bool _isLoading = true;
  late TabController _tabController;

  late ProjectService projectService;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    projectService = ref.read(projectServiceProvider);
    _loadProject();
  }

  Future<void> _loadProject() async {
    final project = await projectService.getProjectById(widget.projectId);
    if (project != null) {
      project.analysis = await projectService.getAnalysisForProject(widget.projectId);
      debugPrint(project.toString());
      setState(() {
        _project = project;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =  const Color(0xFF121212);
    final cardColor = const Color(0xFF1E1E1E);
    final textColor =  Colors.white;
    final subtitleColor =  const Color(0xFFA0A0A0);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: _isLoading
          ? _buildLoadingState(textColor, subtitleColor)
          : _project == null
              ? _buildErrorState(textColor)
              : _buildProjectContent(
                  context,
                  _project!,
                  isDarkMode,
                  cardColor,
                  textColor,
                  subtitleColor,
                ),
    );
  }

  Widget _buildLoadingState(Color textColor, Color subtitleColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00C853)),
          ),
          const SizedBox(height: 20),
          Text(
            'Chargement du projet...',
            style: TextStyle(
              fontSize: 16,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Projet non trouvé',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Le projet avec l\'ID ${widget.projectId} n\'existe pas',
            style: TextStyle(
              fontSize: 16,
              color: textColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadProject,
            child: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectContent(
    BuildContext context,
    Project project,
    bool isDarkMode,
    Color cardColor,
    Color textColor,
    Color subtitleColor,
  ) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverToBoxAdapter(
            child: _buildProjectHeader(project, cardColor, textColor, subtitleColor),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: subtitleColor,
                indicatorColor: Colors.green[500],
                tabs: const [
                  Tab(text: 'Aperçu')
                ],
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(project, cardColor, textColor, subtitleColor)
        ],
      ),
    );
  }

  Widget _buildProjectHeader(Project project, Color cardColor, Color textColor, Color subtitleColor) {
    final statusColor = _getStatusColor(project);
    final statusText = _getStatusText(project);

    return Container(
      padding: const EdgeInsets.all(16),
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Projets',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  project.name,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title and status
          Row(
            children: [
              Expanded(
                child: Text(
                  project.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Metadata
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: subtitleColor),
              const SizedBox(width: 4),
              Text(
                'Créé le ${_formatDate(project.createdAt.toDate())}',
                style: TextStyle(fontSize: 14, color: subtitleColor),
              ),
              const SizedBox(width: 16),
              Icon(Icons.analytics, size: 16, color: subtitleColor),
              const SizedBox(width: 4),
              Text(
                '${project.analysis.length} analyses',
                style: TextStyle(fontSize: 14, color: subtitleColor),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MediaUploadPage(projectId: project.id))),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Nouvelle Analyse'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00C853),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              /*PopupMenuButton<String>(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('Modifier le projet'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: ListTile(
                      leading: Icon(Icons.copy),
                      title: Text('Dupliquer'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'export',
                    child: ListTile(
                      leading: Icon(Icons.download),
                      title: Text('Exporter les données'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'share',
                    child: ListTile(
                      leading: Icon(Icons.share),
                      title: Text('Partager'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text('Supprimer le projet', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade800),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.more_vert),
                ),
              ),*/
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(Project project, Color cardColor, Color textColor, Color subtitleColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Stats cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.4,
            children: [
              _buildStatCard(
                icon: Icons.document_scanner,
                label: 'Analyses',
                value: project.analysis.length.toString(),
                bgColor: const Color(0xFFE8F5E9),
                iconColor: const Color(0xFF00C853),
                textColor: textColor,
                subtitleColor: subtitleColor,
              ),
              _buildStatCard(
                icon: Icons.photo,
                label: 'Fichiers',
                value: project.analysis.fold(0, (sum, a) => sum + a.files.length).toString(),
                bgColor: const Color(0xFFE3F2FD),
                iconColor: const Color(0xFF2196F3),
                textColor: textColor,
                subtitleColor: subtitleColor,
              ),
              _buildStatCard(
                icon: Icons.warning,
                label: 'Défauts détectés',
                value: '0',
                bgColor: const Color(0xFFFFF8E1),
                iconColor: const Color(0xFFFFC107),
                textColor: textColor,
                subtitleColor: subtitleColor,
              ),
              _buildStatCard(
                icon: Icons.calendar_today,
                label: 'Dernière analyse',
                value: project.analysis.isNotEmpty 
                //todo add relative date
                    ? ''
                    : '-',
                bgColor: const Color(0xFFF3E5F5),
                iconColor: const Color(0xFF9C27B0),
                textColor: textColor,
                subtitleColor: subtitleColor,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Latest analyses
          Card(
            color: cardColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dernières analyses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...project.analysis.take(3).map((analysis) {
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade800),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Analyse #${project.analysis.indexOf(analysis) + 1}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ' ${analysis.files.length} fichiers',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: subtitleColor,
                                ),
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 80,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: analysis.files.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      width: 80,
                                      height: 80,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: analysis.files[index].contains('uploads')
                                                  ? NetworkImage('https://th.bing.com/th/id/OIP.fLz_nyWcsH8YBnUzKD8eCAHaFl?rs=1&pid=ImgDetMain') // Put your placeholder URL here
                                                  : FileImage(File(analysis.files[index])) as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color bgColor,
    required Color iconColor,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return Card(
      color: bgColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: subtitleColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper functions
  String _formatDate(DateTime date) {
    return DateFormat('d MMM, h:mm a').format(date);
  }

  Color _getStatusColor(Project project) {
    if (project.analysis.isEmpty) return Colors.grey;
    if (project.analysis.length < 3) return const Color(0xFFFFC107);
    return const Color(0xFF00C853);
  }

  String _getStatusText(Project project) {
    if (project.analysis.isEmpty) return 'Nouveau';
    if (project.analysis.length < 3) return 'En cours';
    return 'Actif';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black87,
      child: _tabBar,
    );
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class AnalysisResult {
  final int defects;
  final String severity;

  AnalysisResult({
    this.defects = 0,
    this.severity = 'low',
  });
}