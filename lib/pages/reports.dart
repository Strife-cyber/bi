import 'package:internship/widgets/media_preview.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship/models/project.dart';
import 'package:internship/services/project_service.dart';

class AnalysisResultsPage extends ConsumerStatefulWidget {
  const AnalysisResultsPage({super.key});

  @override
  ConsumerState<AnalysisResultsPage> createState() => _AnalysisResultsPageState();
}

class _AnalysisResultsPageState extends ConsumerState<AnalysisResultsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _expandedProjects = [];
  List<Project> _projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  Future<void> _fetchProjects() async {
    try {
      final projectService = ref.read(projectServiceProvider);
      final projects = await projectService.getProjects();
      final analysisFutures = projects.map((p) => 
          projectService.getAnalysisForProject(p.id)
      );

      final analyses = await Future.wait(analysisFutures);
      
      setState(() {
        _projects = projects.asMap().entries.map((entry) {
          return entry.value.copyWith(analysis: analyses[entry.key]);
        }).toList();

        _isLoading = false;
      });
    } catch (e) {
      // Add error handling/logging
      throw Exception('Failed to load projects: $e');
    }
  }

  List<Project> get _filteredProjects {
    if (_searchQuery.isEmpty) return _projects;
    return _projects
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _toggleProject(String projectId) {
    setState(() {
      if (_expandedProjects.contains(projectId)) {
        _expandedProjects.remove(projectId);
      } else {
        _expandedProjects.add(projectId);
      }
    });
  }

  String _getClassName(String classId) {
    const classNames = {
      '0': 'Fissure',
      '1': 'Corrosion',
      '2': 'Déformation',
      '3': 'Dommage',
    };
    return classNames[classId] ?? 'Classe $classId';
  }

  Future<void> _downloadReport(String projectId, int analysisIndex) async {
    // TODO: Implement download functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Téléchargement du rapport pour le projet $projectId'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.white;
    final cardColor = Colors.grey[800];
    final borderColor = Colors.grey[700]!;
    final secondaryTextColor = Colors.grey[400];

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Rechercher un projet...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.green.shade500,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Colors.green.shade500,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Projects list
                  Expanded(
                    child: _filteredProjects.isEmpty
                        ? _buildEmptyState(textColor, secondaryTextColor!)
                        : ListView.builder(
                            itemCount: _filteredProjects.length,
                            itemBuilder: (context, projectIndex) {
                              final project = _filteredProjects[projectIndex];
                              final isExpanded = _expandedProjects.contains(project.id);
                              
                              return Card(
                                elevation: 2,
                                margin: const EdgeInsets.only(bottom: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: borderColor,
                                    width: 1,
                                  ),
                                ),
                                color: cardColor,
                                child: Column(
                                  children: [
                                    // Project header
                                    ListTile(
                                      onTap: () => _toggleProject(project.id),
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Colors.teal, Colors.green],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.business,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        project.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: textColor,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${DateFormat('MMM d, h:mm a').format(project.createdAt.toDate())} • ${project.analysis.length} analyse${project.analysis.length > 1 ? 's' : ''}',
                                        style: TextStyle(
                                          color: secondaryTextColor,
                                        ),
                                      ),
                                      trailing: Icon(
                                        isExpanded
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                    // Analyses (collapsible)
                                    if (isExpanded)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          bottom: 16,
                                        ),
                                        child: Column(
                                          children: project.analysis
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                            final analysisIndex = entry.key;
                                            final analysis = entry.value;
                                            debugPrint(analysis.toString());
                                            
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 16),
                                              child: Column(
                                                children: [
                                                  // Analysis header
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      // Tree line and dot
                                                      Column(
                                                        children: [
                                                          Container(
                                                            width: 16,
                                                            height: 16,
                                                            decoration: BoxDecoration(
                                                              color: Colors.green,
                                                              shape: BoxShape.circle,
                                                              border: Border.all(
                                                                color: Colors.grey[800]!,
                                                                width: 2,
                                                              ),
                                                            ),
                                                          ),
                                                          if (analysisIndex <
                                                              project.analysis.length - 1)
                                                            Container(
                                                              width: 2,
                                                              height: 40,
                                                              color: Colors.green[700]
                                                            ),
                                                        ],
                                                      ),
                                                      const SizedBox(width: 8),
                                                      // Analysis content
                                                      Expanded(
                                                        child: Card(
                                                          elevation: 0,
                                                          color: Colors.grey[700],
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(8),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets.all(4),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons.search,
                                                                      size: 20,
                                                                      color: Colors.green,
                                                                    ),
                                                                    const SizedBox(width: 8),
                                                                    Text(
                                                                      'Analyse #${analysisIndex + 1}',
                                                                      style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize: 16,
                                                                        color: textColor,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(width: 8),
                                                                    Text(
                                                                      DateFormat('MMM d, h:mm a').format(project.createdAt.toDate()),
                                                                      style: TextStyle(
                                                                        color:
                                                                            secondaryTextColor,
                                                                        fontSize: 12,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(height: 12),
                                                                // Files analyzed
                                                                Text(
                                                                  'Fichiers analysés (${analysis.files.length})',
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight.w500,
                                                                    color: secondaryTextColor,
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 8),
                                                                Center(
                                                                  child: Wrap(
                                                                    spacing: 8,
                                                                    runSpacing: 8,
                                                                    children: analysis.files
                                                                        .map((file) =>
                                                                            _buildFilePreview(
                                                                                file))
                                                                        .toList(),
                                                                  ),
                                                                ),
                                                                const SizedBox(height: 12),
                                                                // Results table
                                                                if (analysis.result != null && 
                                                                    analysis.result!.isNotEmpty && 
                                                                    analysis.result!.length == analysis.files.length) 

                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      children: [
                                                                        Text(
                                                                          'Détails des Détections',
                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            color: secondaryTextColor,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(height: 8),
                                                                        SizedBox(
                                                                          height: MediaQuery.of(context).size.height * 0.5, // Fixed height container
                                                                          child: SingleChildScrollView(
                                                                            scrollDirection: Axis.vertical,
                                                                            child: SingleChildScrollView(
                                                                              scrollDirection: Axis.horizontal,
                                                                              child: DataTable(
                                                                                columnSpacing: 16,
                                                                                // ignore: deprecated_member_use
                                                                                dataRowHeight: 80, // Fixed row height instead of min height
                                                                                headingRowHeight: 56,
                                                                                columns: const [
                                                                                  DataColumn(
                                                                                    label: Text(
                                                                                      'Fichier',
                                                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                  DataColumn(
                                                                                    label: Text(
                                                                                      'Type',
                                                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                  DataColumn(
                                                                                    label: Text(
                                                                                      'Détections',
                                                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                  DataColumn(
                                                                                    label: Text(
                                                                                      'Résultats',
                                                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                                rows: List<DataRow>.generate(
                                                                                  analysis.files.length,
                                                                                  (index) {
                                                                                    final file = analysis.files[index];
                                                                                    final result = analysis.result![index];
                                                                                    
                                                                                    return DataRow(
                                                                                      cells: [
                                                                                        DataCell(
                                                                                          SizedBox(
                                                                                            width: 100,
                                                                                            child: _buildFilePreview(file),
                                                                                          ),
                                                                                        ),
                                                                                        DataCell(
                                                                                          Container(
                                                                                            padding: const EdgeInsets.symmetric(
                                                                                              horizontal: 8,
                                                                                              vertical: 4,
                                                                                            ),
                                                                                            decoration: BoxDecoration(
                                                                                              color: result['type'] == 'image'
                                                                                                  ? const Color.fromRGBO(13, 71, 161, 1)
                                                                                                  : Colors.purple[900],
                                                                                              borderRadius: BorderRadius.circular(12),
                                                                                            ),
                                                                                            child: Text(
                                                                                              result['type'] == 'image' ? 'Image' : 'Vidéo',
                                                                                              style: TextStyle(
                                                                                                color: result['type'] == 'image'
                                                                                                    ? Colors.blue[100]
                                                                                                    : Colors.purple[100],
                                                                                                fontSize: 12,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        DataCell(
                                                                                          SizedBox(
                                                                                            width: 150,
                                                                                            child: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Text(
                                                                                                  '${result['valid_detections']} détections',
                                                                                                  style: TextStyle(color: textColor),
                                                                                                ),
                                                                                                const SizedBox(height: 4),
                                                                                                LinearProgressIndicator(
                                                                                                  value: result['valid_detections'] /
                                                                                                      (result['type'] == 'video'
                                                                                                          ? result['frames_analyzed']
                                                                                                          : 1),
                                                                                                  backgroundColor: Colors.green[900],
                                                                                                  color: Colors.green,
                                                                                                  minHeight: 8,
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        DataCell(
                                                                                          SizedBox(
                                                                                            width: 120,
                                                                                            child: Column(
                                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: (result['class_distribution'] as Map<String, dynamic>)
                                                                                                  .entries
                                                                                                  .map((entry) {
                                                                                                return Padding(
                                                                                                  padding: const EdgeInsets.only(bottom: 4),
                                                                                                  child: SingleChildScrollView(
                                                                                                    scrollDirection: Axis.horizontal,
                                                                                                    child: Row(
                                                                                                      children: [
                                                                                                        Container(
                                                                                                          width: 12,
                                                                                                          height: 12,
                                                                                                          margin: const EdgeInsets.only(right: 4),
                                                                                                          decoration: BoxDecoration(
                                                                                                            color: entry.key == '0'
                                                                                                                ? Colors.red
                                                                                                                : entry.key == '1'
                                                                                                                    ? Colors.orange
                                                                                                                    : entry.key == '2'
                                                                                                                        ? Colors.blue
                                                                                                                        : Colors.green,
                                                                                                            shape: BoxShape.circle,
                                                                                                          ),
                                                                                                        ),
                                                                                                        Text(
                                                                                                          '${_getClassName(entry.key)}: ',
                                                                                                          style: TextStyle(
                                                                                                            fontWeight: FontWeight.bold,
                                                                                                            color: textColor,
                                                                                                          ),
                                                                                                        ),
                                                                                                        Text(
                                                                                                          '${entry.value} détection${entry.value > 1 ? 's' : ''}',
                                                                                                          style: TextStyle(
                                                                                                            color: secondaryTextColor,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                              }).toList(),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    );
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),

                                                                const SizedBox(height: 12),
                                                                // Download button
                                                                Align(
                                                                  alignment:
                                                                      Alignment.centerRight,
                                                                  child: TextButton.icon(
                                                                    icon: const Icon(
                                                                        Icons.download,
                                                                        size: 16),
                                                                    label: const Text(
                                                                        'Télécharger'),
                                                                    onPressed: () =>
                                                                        _downloadReport(
                                                                            project.id,
                                                                            analysisIndex),
                                                                    style: TextButton
                                                                        .styleFrom(
                                                                      foregroundColor:
                                                                          Colors.green,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFilePreview(String fileUrl) {
    return MediaPreview(url: fileUrl);
  }

  Widget _buildEmptyState(Color textColor, Color secondaryTextColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:[Colors.grey[800]!, Colors.grey[700]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search,
              size: 48,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucun résultat trouvé',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Aucun projet ne correspond à vos critères de recherche.\n'
            'Essayez de modifier vos filtres ou créez un nouveau projet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectSearchDelegate extends SearchDelegate<String> {
  final List<Project> projects;

  ProjectSearchDelegate(this.projects);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredProjects = query.isEmpty
        ? projects
        : projects
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: filteredProjects.length,
      itemBuilder: (context, index) {
        final project = filteredProjects[index];
        return ListTile(
          title: Text(project.name),
          onTap: () {
            close(context, project.id);
          },
        );
      },
    );
  }
}

class AnalysisResult {
  final String severity;
  final List<Detection> detections;

  AnalysisResult({
    required this.severity,
    required this.detections,
  });
}

class Detection {
  final String type;
  final int validDetections;
  final int framesAnalyzed;
  final Map<String, int> classDistribution;

  Detection({
    required this.type,
    required this.validDetections,
    required this.framesAnalyzed,
    required this.classDistribution,
  });
}