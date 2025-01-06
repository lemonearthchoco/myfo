class ObjectImage {
  final String id;
  final String image;

  ObjectImage({required this.id, required this.image});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image
    };
  }

  // JSON 역직렬화
  factory ObjectImage.fromJson(Map<String, dynamic> json) {
    return ObjectImage(
      id: json['id'],
      image: json['image']
    );
  }
}
