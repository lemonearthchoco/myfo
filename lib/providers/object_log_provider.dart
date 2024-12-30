import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:myfo/models/object_image.dart';
import 'package:myfo/models/object_log.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/object_pattern.dart';

class ObjectLogProvider extends ChangeNotifier {
  List<ObjectLog> _logs = [];

  List<ObjectLog> get logs => List.from(_logs)
    ..sort((a, b) {
      if (a.finishedAt == null && b.finishedAt == null) return 0;
      if (a.finishedAt == null) return 1; // null 값을 뒤로 보냄
      if (b.finishedAt == null) return -1; // null 값을 뒤로 보냄
      return b.finishedAt!.compareTo(a.finishedAt!); // 내림차순
    });

  List<ObjectLog> get favoriteLogs =>
      List.from(_logs.where((log) => log.isFavorite))
        ..sort((a, b) {
          if (a.likedAt == null && b.likedAt == null) return 0;
          if (a.likedAt == null) return 1; // null 값을 뒤로 보냄
          if (b.likedAt == null) return -1; // null 값을 뒤로 보냄
          return b.likedAt!.compareTo(a.likedAt!); // 내림차순
        });

  final List<ObjectLog> initialLogs = [
    ObjectLog(
      id: const Uuid().v4(),
      title: "니트 가방",
      subtitle: "라벤더향 가방",
      pattern: ObjectPattern(
          type: 'url',
          content:
              'https://lemonearthchoco.s3.ap-northeast-2.amazonaws.com/myfo/2024/12/IMG_8658.HEIC'),
      images: [
        ObjectImage(
            id: const Uuid().v4(),
            image:
                "https://lemonearthchoco.s3.ap-northeast-2.amazonaws.com/myfo/2024/12/IMG_8658.HEIC")
      ],
      description:
          "이거 뜨는데 7개월이나 걸림 진짜 대박 어려움 그리고 서술형 도안임 그래도 너무너무 이쁘다. 다시 입고 싶은 이유가 뭔지 알겠다. 진짜 너무 존예 볼때마다 행복해져",
      tags: ["탑다운", "새글런", "기성복"],
      needles: ["니트프로 진저 스페셜 3.0mm", "니트프로 진저 스페셜 4.0mm", "니트프로 진저 디럭스 4.0mm"],
      yarns: ["솜솜뜨개 프빌 포레스트 2합"],
      gauges: ["21코 37단"],
      finishedAt: DateTime(2024, 9, 1),
    ),
    ObjectLog(
      id: const Uuid().v4(),
      title: "니드모어 스웨터",
      subtitle: "포레스트 니트",
      pattern: ObjectPattern(type: 'text', content: '김대리의 데일리 뜨개'),
      images: [
        ObjectImage(
            id: const Uuid().v4(),
            image:
                "https://lemonearthchoco.s3.ap-northeast-2.amazonaws.com/myfo/2024/12/IMG_5667.HEIC"),
        ObjectImage(
            id: const Uuid().v4(),
            image:
                "https://image.msscdn.net/thumbnails/images/goods_img/20241002/4480313/4480313_17338815224904_big.jpg?w=1200")
      ],
      description: "바텀업으로 뜨는 니트",
      tags: ["바텀업"],
      needles: ["니트프로 진저 디럭스 4.0mm", "니트프로 진저 디럭스 5.0mm", "치아오구 밤부 5.0mm"],
      yarns: ["솜솜뜨개 수플레 글루미 스카이"],
      gauges: [],
      finishedAt: DateTime(2024, 12, 20),
    ),
    ObjectLog(
      id: const Uuid().v4(),
      title: "카멜리아 그물백",
      subtitle: "",
      pattern: ObjectPattern(
          type: 'url', content: 'https://www.youtube.com/watch?v=2MB077qFgM4'),
      images: [
        ObjectImage(
            id: const Uuid().v4(),
            image:
                "https://lemonearthchoco.s3.ap-northeast-2.amazonaws.com/myfo/2024/12/IMG_5688.HEIC")
      ],
      description: "도토리 햇",
      tags: [],
      needles: ["니트프로 진저 스페셜 3.0mm", "니트프로 진저 스페셜 4.0mm", "니트프로 진저 디럭스 4.0mm"],
      yarns: ["솜솜뜨개 프빌 포레스트 2합"],
      gauges: [],
      finishedAt: DateTime(2024, 12, 28),
    ),
    ObjectLog(
      id: const Uuid().v4(),
      title: "블랙베리 아란 스웨터",
      subtitle: "",
      pattern: ObjectPattern(
          type: 'url', content: 'https://www.youtube.com/watch?v=2MB077qFgM4'),
      images: [
        ObjectImage(
            id: const Uuid().v4(),
            image:
                "https://lemonearthchoco.s3.ap-northeast-2.amazonaws.com/myfo/2024/12/IMG_5683.HEIC")
      ],
      description: "모헤어 장갑",
      tags: ["장갑 바늘"],
      needles: ["니트프로 진저 스페셜 3.0mm", "니트프로 진저 스페셜 4.0mm", "니트프로 진저 디럭스 4.0mm"],
      yarns: ["솜솜뜨개 프빌 포레스트 2합"],
      gauges: [],
      finishedAt: DateTime(2024, 9, 1),
    ),

    ObjectLog(
      id: const Uuid().v4(),
      title: "dotori hat",
      subtitle: "도토리 모자",
      pattern: ObjectPattern(
          type: 'url', content: 'https://www.youtube.com/watch?v=2MB077qFgM4'),
      images: [
        ObjectImage(
            id: const Uuid().v4(),
            image:
            "https://lemonearthchoco.s3.ap-northeast-2.amazonaws.com/myfo/2024/12/IMG_5674.HEIC")
      ],
      description: "도토리 모자",
      tags: ["장갑 바늘"],
      needles: ["니트프로 진저 스페셜 3.0mm", "니트프로 진저 스페셜 4.0mm", "니트프로 진저 디럭스 4.0mm"],
      yarns: ["솜솜뜨개 프빌 포레스트 2합"],
      gauges: [],
      finishedAt: DateTime(2024, 12, 29),
    ),
    ObjectLog(
      id: const Uuid().v4(),
      title: "홈스펀 숏비니",
      subtitle: "",
      pattern: ObjectPattern(
          type: 'url', content: 'https://www.youtube.com/watch?v=2MB077qFgM4'),
      images: [
        ObjectImage(
            id: const Uuid().v4(),
            image:
            "https://lemonearthchoco.s3.ap-northeast-2.amazonaws.com/myfo/2024/12/IMG_5657.HEIC")
      ],
      description: "모헤어 장갑1",
      tags: ["장갑 바늘"],
      needles: ["니트프로 진저 스페셜 3.0mm", "니트프로 진저 스페셜 4.0mm", "니트프로 진저 디럭스 4.0mm"],
      yarns: ["솜솜뜨개 프빌 포레스트 2합"],
      gauges: [],
      finishedAt: DateTime(2024, 10, 15),
    ),
  ];

  Future<void> loadLogs({bool forceReset = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? logsJson = prefs.getString(ObjectLog.name);

    if (logsJson != null && !forceReset) {
      final List<dynamic> jsonList = json.decode(logsJson);
      _logs = jsonList.map((json) => ObjectLog.fromJson(json)).toList();
    } else {
      // _logs = initialLogs;
      await _saveLogs();
    }
    notifyListeners();
  }

  Future<ObjectLog?> getLogById(String id) async {
    return logs.firstWhere((log) => log.id == id);
  }

  Future<void> addLog(ObjectLog log) async {
    _logs.add(log);
    await _saveLogs();
    notifyListeners();
  }

  Future<void> updateLog(String id, ObjectLog newLog) async {
    int index = _logs.indexWhere((log) => log.id == id);
    if (index >= 0) {
      _logs[index] = newLog;
    } else {
      throw Exception("업데이트 중 오류가 발생했습니다.");
    }
    await _saveLogs();
    notifyListeners();
  }

  Future<void> likeLog(String id) async {
    int index = _logs.indexWhere((log) => log.id == id);
    if (index >= 0) {
      _logs[index].like();
    }
    await _saveLogs();
    notifyListeners();
  }

  Future<void> unlikeLog(String id) async {
    int index = _logs.indexWhere((log) => log.id == id);
    if (index >= 0) {
      _logs[index].unlike();
    }
    await _saveLogs();
    notifyListeners();
  }

  Future<void> deleteLog(String id) async {
    _logs.removeWhere((log) => log.id == id);
    await _saveLogs();
    notifyListeners();
  }

  Future<void> _saveLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final String logsJson =
        json.encode(_logs.map((log) => log.toJson()).toList());
    await prefs.setString(ObjectLog.name, logsJson);
  }
}
