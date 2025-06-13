import 'package:flutter/foundation.dart';
import 'package:internship/models/project.dart';
import 'package:internship/models/analysis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internship/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:internship/services/sembast_service.dart';

final projectServiceProvider = Provider((ref) => ProjectService(uid: ref.read(authServiceProvider).currentUser!.uid));

class ProjectService {
  late FirebaseFirestore _firestore;
  late String _userId;
  late CollectionReference<Map<String, dynamic>> _projectsCollection;

  ProjectService({ required String uid }) {
    _userId = uid;
    _firestore = FirebaseFirestore.instance;
    _projectsCollection = _firestore.collection('users').doc(uid).collection('projects');
  }

  Future<Project?> createProject(Project project) async {
    try {
      final docRef = _projectsCollection.doc();
      final payload = {
        ...project.toMap(),
        'id': docRef.id,
      };
      await docRef.set(payload);
      return Project.fromMap(payload);
    } catch (e) {
      debugPrint('Error creating project: $e');
      return null;
    }
  }

  Future<List<Project>> getProjects() async {
    try {
      final snap = await _projectsCollection.get();
      return snap.docs.map((doc) => Project.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint('Error getting projects: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getProjectById(String projectId) async {
    try {
      final docRef = _projectsCollection.doc(projectId);
      final snap = await docRef.get();
      return snap.exists ? snap.data() : null;
    } catch (e) {
      debugPrint('Error fetching project by ID: $e');
      return null;
    }
  }

  Future<void> updateProject(String projectId, Map<String, dynamic> updates) async {
    try {
      final docRef = _projectsCollection.doc(projectId);
      await docRef.update({
        ...updates,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating project: $e');
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _projectsCollection.doc(projectId).delete();
    } catch (e) {
      debugPrint('Error deleting project: $e');
    }
  }

  /// ANALYSIS SUBCOLLECTION

  CollectionReference<Map<String, dynamic>> getAnalysisCollection(String projectId) {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('projects')
        .doc(projectId)
        .collection('analysis');
  }

  Future<void> addAnalysis(String projectId, Map<String, dynamic> analysis) async {
    try {
      final analysisCollection = getAnalysisCollection(projectId);
      final ref = analysisCollection.doc();
      await ref.set(analysis);
    } catch (e) {
      debugPrint('Error adding analysis: $e');
    }
  }

  Future<List<Analysis>> getAnalysisForProject(String projectId) async {
    try {
      final snap = await getAnalysisCollection(projectId).get();
      return snap.docs.map((doc) => Analysis.fromMap(doc.data())).toList();
    } catch (e) {
      debugPrint('Error getting analysis for project: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getAllAnalysisForUser() async {
    final results = <Map<String, dynamic>>[];

    try {
      final projectsSnap = await _projectsCollection.get();

      for (final projectDoc in projectsSnap.docs) {
        final projectId = projectDoc.id;
        final analysisSnap = await getAnalysisCollection(projectId).get();

        results.add({
          'projectId': projectId,
          'analysis': analysisSnap.docs.map((doc) => doc.data()).toList(),
        });
      }
    } catch (e) {
      debugPrint('Error getting all analysis: $e');
    }

    return results;
  }

  Future<void> deleteAnalysis(String projectId, String analysisId) async {
    try {
      final ref = getAnalysisCollection(projectId).doc(analysisId);
      await ref.delete();
    } catch (e) {
      debugPrint('Error deleting analysis: $e');
    }
  }

  Future<void> syncFromFirestoreToSembast(SembastService sembast) async {
    final projects = await getProjects();

    for (final project in projects) {
      final projectId = project.id;

      final analysis = await getAnalysisForProject(projectId);

      final localProject = Project(
        id: projectId,
        name: project.name,
        description: project.description,
        createdAt: project.createdAt,
        updatedAt: project.updatedAt,
        analysis: analysis,
      );

      await sembast.set('projects', projectId, localProject.toMap());
    }
  }

  Future<void> syncFromSembastToFirestore(SembastService sembast) async {
    final localProjects = await sembast.getAll('projects');

    for (final map in localProjects) {
      final localProject = Project.fromMap(map);
      final projectId = localProject.id;

      // Ensure the project exists or is updated online
      await updateProject(projectId, {
        'name': localProject.name,
        'description': localProject.description,
        'createdAt': localProject.createdAt,
        'updatedAt': localProject.updatedAt,
      });

      // Sync each analysis item
      for (final analysis in localProject.analysis) {
        await addAnalysis(projectId, analysis.toMap());
      }
    }
  }
}
