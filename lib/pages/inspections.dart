import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Inspections extends ConsumerStatefulWidget {
  const Inspections({super.key});

  @override
  ConsumerState<Inspections> createState() => _InspectionsState();
}

class _InspectionsState extends ConsumerState<Inspections>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _showCreateDialog = false;
  bool _isLoading = false;
  String _activeFilter = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);
    final filteredProjects = _getFilteredProjects(projects);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            _buildHeader(),
            
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Stats Cards
                    _buildStatsCards(projects),
                    
                    const SizedBox(height: 24),
                    
                    // Filter Tabs
                    _buildFilterTabs(projects),
                    
                    const SizedBox(height: 16),
                    
                    // Projects Grid
                    _buildProjectsGrid(filteredProjects),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildCreateProjectFAB(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mes Inspections',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Gérez vos inspections et analyses de bâtiments',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _showCreateDialog = true),
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  padding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Rechercher un projet...',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(List<Project> projects) {
    final stats = [
      StatCard(
        title: 'Total Projets',
        value: projects.length.toString(),
        icon: Icons.folder_rounded,
        color: const Color(0xFF10B981),
        bgColor: const Color(0xFF10B981).withValues(alpha: 0.1),
      ),
      StatCard(
        title: 'Analyses',
        value: projects.fold(0, (sum, p) => sum + p.analyses.length).toString(),
        icon: Icons.analytics_rounded,
        color: const Color(0xFF3B82F6),
        bgColor: const Color(0xFF3B82F6).withValues(alpha: 0.1),
      ),
      StatCard(
        title: 'Fichiers',
        value: projects.fold(0, (sum, p) => 
          sum + p.analyses.fold(0, (s, a) => s + a.files.length)).toString(),
        icon: Icons.photo_library_rounded,
        color: const Color(0xFF8B5CF6),
        bgColor: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
      ),
      StatCard(
        title: 'Cette semaine',
        value: projects.where((p) => 
          DateTime.now().difference(p.updatedAt).inDays <= 7).length.toString(),
        icon: Icons.calendar_today_rounded,
        color: const Color(0xFFF59E0B),
        bgColor: const Color(0xFFF59E0B).withValues(alpha: 0.1),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => _buildStatCard(stats[index]),
    );
  }

  Widget _buildStatCard(StatCard stat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: stat.bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  stat.icon,
                  color: stat.color,
                  size: 20,
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            stat.value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(List<Project> projects) {
    final filters = [
      FilterTab('all', 'Tous', projects.length),
      FilterTab('active', 'Actifs', projects.where((p) => p.analyses.isNotEmpty).length),
      FilterTab('recent', 'Récents', projects.where((p) => 
        DateTime.now().difference(p.updatedAt).inDays <= 7).length),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: filters.map((filter) => Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _activeFilter = filter.key),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _activeFilter == filter.key 
                    ? const Color(0xFF10B981).withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    filter.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _activeFilter == filter.key 
                          ? const Color(0xFF10B981)
                          : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: _activeFilter == filter.key 
                          ? const Color(0xFF10B981)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      filter.count.toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _activeFilter == filter.key 
                            ? Colors.white
                            : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildProjectsGrid(List<Project> projects) {
    if (projects.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) => _buildProjectCard(projects[index]),
    );
  }

  Widget _buildProjectCard(Project project) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Créé le ${_formatDate(project.createdAt)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(project).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(project),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(project),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Stats
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              project.analyses.length.toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF10B981),
                              ),
                            ),
                            Text(
                              'Analyses',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              project.analyses.fold(0, (sum, a) => sum + a.files.length).toString(),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3B82F6),
                              ),
                            ),
                            Text(
                              'Fichiers',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Progress Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progression',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            '${_getCompletionRate(project)}%',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _getCompletionRate(project) / 100,
                        backgroundColor: Colors.grey[200],
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                        minHeight: 6,
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _openProject(project),
                          icon: const Icon(Icons.folder_open_rounded, size: 16),
                          label: const Text('Ouvrir'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _showProjectActions(project),
                        icon: const Icon(Icons.more_vert_rounded),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[100],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open_rounded,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun projet trouvé',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Créez votre premier projet pour commencer',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => setState(() => _showCreateDialog = true),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Créer un projet'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateProjectFAB() {
    return FloatingActionButton.extended(
      onPressed: () => setState(() => _showCreateDialog = true),
      backgroundColor: const Color(0xFF10B981),
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add_rounded),
      label: const Text('Nouveau Projet'),
    );
  }

  List<Project> _getFilteredProjects(List<Project> projects) {
    var filtered = projects;

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((p) => 
        p.name.toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }

    // Apply active filter
    switch (_activeFilter) {
      case 'active':
        filtered = filtered.where((p) => p.analyses.isNotEmpty).toList();
        break;
      case 'recent':
        filtered = filtered.where((p) => 
          DateTime.now().difference(p.updatedAt).inDays <= 7
        ).toList();
        break;
    }

    return filtered;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getStatusColor(Project project) {
    if (project.analyses.isEmpty) return Colors.grey;
    if (project.analyses.length < 5) return const Color(0xFFF59E0B);
    return const Color(0xFF10B981);
  }

  String _getStatusText(Project project) {
    if (project.analyses.isEmpty) return 'Nouveau';
    if (project.analyses.length < 5) return 'En cours';
    return 'Actif';
  }

  double _getCompletionRate(Project project) {
    if (project.analyses.isEmpty) return 0;
    return (project.analyses.length / 10 * 100).clamp(0, 100);
  }

  void _openProject(Project project) {
    // Navigate to project detail page
    Navigator.pushNamed(context, '/project/${project.id}');
  }

  void _showProjectActions(Project project) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_rounded),
              title: const Text('Modifier'),
              onTap: () {
                Navigator.pop(context);
                // Edit project
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy_rounded),
              title: const Text('Dupliquer'),
              onTap: () {
                Navigator.pop(context);
                // Duplicate project
              },
            ),
            ListTile(
              leading: const Icon(Icons.share_rounded),
              title: const Text('Partager'),
              onTap: () {
                Navigator.pop(context);
                // Share project
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_rounded, color: Colors.red),
              title: const Text('Supprimer', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                // Delete project
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Data Models
class Project {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Analysis> analyses;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.analyses,
  });
}

class Analysis {
  final String id;
  final String name;
  final List<String> files;
  final DateTime createdAt;

  Analysis({
    required this.id,
    required this.name,
    required this.files,
    required this.createdAt,
  });
}

class StatCard {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;

  StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });
}

class FilterTab {
  final String key;
  final String label;
  final int count;

  FilterTab(this.key, this.label, this.count);
}

// Mock Provider
final projectsProvider = StateProvider<List<Project>>((ref) => [
  Project(
    id: '1',
    name: 'Inspection Bâtiment A',
    description: 'Inspection complète du bâtiment principal',
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    analyses: [
      Analysis(
        id: '1',
        name: 'Analyse structurelle',
        files: ['photo1.jpg', 'photo2.jpg'],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ],
  ),
  Project(
    id: '2',
    name: 'Contrôle Sécurité',
    description: 'Vérification des systèmes de sécurité',
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    analyses: [],
  ),
]);