import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:internship/models/analysis.dart';

class Project {
  final String id;
  final String name;
  final String description;
  final String createdAt;
  final String updatedAt;
  final List<Analysis> analysis;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.analysis,
  });

  Project copyWith({
    String? id,
    String? name,
    String? description,
    String? createdAt,
    String? updatedAt,
    List<Analysis>? analysis,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      analysis: analysis ?? this.analysis,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'analysis': analysis.map((x) => x.toMap()).toList(),
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      createdAt: map['createdAt'] as String,
      updatedAt: map['updatedAt'] as String,
      analysis: List<Analysis>.from((map['analysis'] as List).map<Analysis>((x) => Analysis.fromMap(x as Map<String,dynamic>))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Project.fromJson(String source) => Project.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Project(id: $id, name: $name, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, analysis: $analysis)';
  }

  @override
  bool operator ==(covariant Project other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      listEquals(other.analysis, analysis);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      description.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      analysis.hashCode;
  }
}
