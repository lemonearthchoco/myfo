class ObjectPattern {
  final String type;
  final String content;

  ObjectPattern({required this.type, required this.content});

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'content': content
    };
  }

  // JSON 역직렬화
  factory ObjectPattern.fromJson(Map<String, dynamic> json) {
    return ObjectPattern(
        type: json['type'],
        content: json['content']
    );
  }
}
