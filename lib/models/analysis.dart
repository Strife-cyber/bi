import 'dart:convert';

import 'package:flutter/foundation.dart';

class Analysis {
  List<String> files;
  Map<String, dynamic> result;
  DateTime createdAt;
  DateTime updatedAt;

  Analysis({
    required this.files,
    required this.result,
    required this.createdAt,
    required this.updatedAt
  });

  Analysis copyWith({
    List<String>? files,
    Map<String, dynamic>? result,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Analysis(
      files: files ?? this.files,
      result: result ?? this.result,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'files': files,
      'result': result,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Analysis.fromMap(Map<String, dynamic> map) {
    return Analysis(
      files: List<String>.from((map['files'] as List<String>)),
      result: Map<String, dynamic>.from((map['result'] as Map<String, dynamic>)),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Analysis.fromJson(String source) => Analysis.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Analysis(files: $files, result: $result, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Analysis other) {
    if (identical(this, other)) return true;
  
    return 
      listEquals(other.files, files) &&
      mapEquals(other.result, result) &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return files.hashCode ^
      result.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
  }
}
