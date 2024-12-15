class ObjectLog {
  static final String name = "object_log";

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final List<String> images;
  final List<String> yarns;
  final List<String> needles;
  final List<String> tags;
  final List<String> gauges;
  final DateTime? finishedAt;

  ObjectLog(
      { required this.id,
        required this.title,
      required this.subtitle,
      required this.description,
      required this.images,
      required this.yarns,
      required this.needles,
      required this.tags,
      required this.gauges,
      this.finishedAt});

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'yarns': yarns,
      'needles': needles,
      'tags': tags,
      'gauges': gauges,
      'images': images,
    };
  }

  // JSON 역직렬화
  factory ObjectLog.fromJson(Map<String, dynamic> json) {
    return ObjectLog(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      yarns: List<String>.from(json['yarns']),
      needles: List<String>.from(json['needles']),
      tags: List<String>.from(json['tags']),
      gauges: List<String>.from(json['gauges']),
      images: List<String>.from(json['images']),
    );
  }
}
