import 'package:myfo/models/object_image.dart';

import 'object_pattern.dart';

class ObjectLog {
  static final String name = "object_log";

  final String id; // uuid
  final String title;
  final String subtitle;
  final ObjectPattern pattern;
  final String description;
  final List<ObjectImage> images;
  final List<String> yarns;
  final List<String> needles;
  final List<String> tags;
  final List<String> gauges;
  bool _isFavorite = false;
  DateTime createdAt;
  DateTime? finishedAt;
  DateTime? likedAt;

  bool get isFavorite => _isFavorite;

  set isFavorite(bool isFavorite) => _isFavorite = isFavorite;

  void like() {
    this._isFavorite = true;
    this.likedAt = DateTime.now();
  }

  void unlike() {
    this._isFavorite = false;
    this.likedAt = null;
  }

  ObjectLog(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.pattern,
      required this.description,
      required this.images,
      required this.yarns,
      required this.needles,
      required this.tags,
      required this.gauges,
      this.finishedAt,
      this.likedAt,
      bool isFavorite = false})
      : _isFavorite = isFavorite,
        createdAt = DateTime.now();

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'pattern': {'type': pattern.type, 'content': pattern.content},
      'yarns': yarns,
      'needles': needles,
      'tags': tags,
      'gauges': gauges,
      'isFavorite': isFavorite,
      'images': images.map((image) => image.toJson()).toList(),
      'finishedAt': finishedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'likedAt': likedAt?.toIso8601String()
    };
  }

  // JSON 역직렬화
  factory ObjectLog.fromJson(Map<String, dynamic> json) {
    return ObjectLog(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      pattern: ObjectPattern(
          type: json['pattern']['type'], content: json['pattern']['content']),
      yarns: List<String>.from(json['yarns']),
      needles: List<String>.from(json['needles']),
      tags: List<String>.from(json['tags']),
      gauges: List<String>.from(json['gauges']),
      images: (json['images'] as List<dynamic>)
          .map((imageJson) => ObjectImage.fromJson(imageJson))
          .toList(),
      finishedAt: json['finishedAt'] != null
          ? DateTime.parse(json['finishedAt'])
          : null,
      isFavorite: json['isFavorite'] ?? false,
      // 기본값 처리
      likedAt: json['likedAt'] != null ? DateTime.parse(json['likedAt']) : null,
    );
  }
}
