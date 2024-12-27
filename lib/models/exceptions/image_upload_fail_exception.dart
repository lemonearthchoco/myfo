class ImageUploadFailException implements Exception {
  final String message;

  ImageUploadFailException(this.message);

  @override
  String toString() => "ImageUploadFailException: $message";
}
