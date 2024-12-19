import 'package:myfo/models/object_image.dart';

class ObjectLogParam {

  final String title;
  final String subtitle;
  final String pattern;
  final String description;
  final List<ObjectImage> images;
  final List<String> yarns;
  final List<String> needles;
  final List<String> tags;
  final List<String> gauges;
  final DateTime? finishedAt;

  ObjectLogParam(
      {
        required this.title,
        required this.subtitle,
        required this.pattern,
        required this.description,
        required this.images,
        required this.yarns,
        required this.needles,
        required this.tags,
        required this.gauges,
        this.finishedAt});
}
