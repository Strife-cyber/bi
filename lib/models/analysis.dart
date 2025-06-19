import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Analysis {
  List<String> files;
  dynamic result;
  Timestamp createdAt;
  Timestamp updatedAt;

  Analysis({
    required this.files,
    required this.result,
    required this.createdAt,
    required this.updatedAt
  });

  Analysis copyWith({
    List<String>? files,
    dynamic result,
    Timestamp? createdAt,
    Timestamp? updatedAt,
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
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static Timestamp parseToTimestamp(dynamic value) {
    if (value is Timestamp) {
      return value;
    } else if (value is String) {
      return Timestamp.fromDate(DateTime.parse(value));
    } else if (value is DateTime) {
      return Timestamp.fromDate(value);
    } else {
      throw FormatException('Unsupported format for timestamp: $value');
    }
  }


  factory Analysis.fromMap(Map<String, dynamic> map) {
    final rawFiles = map['files'] as List<dynamic>;
    final files = rawFiles.map((file) => file.toString()).toList();

    return Analysis(
      files: files,
      result: map['result'],
      createdAt: map['createdAt'] as Timestamp,
      updatedAt: parseToTimestamp(map['updatedAt']),
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
      listEquals(other.result, result) &&
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
