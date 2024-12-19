import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:myfo/models/object_image.dart';
import 'package:myfo/models/object_log.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ObjectLogProvider extends ChangeNotifier {
  List<ObjectLog> _logs = [];

  List<ObjectLog> get logs => _logs;

  final List<ObjectLog> initialLogs = [
    ObjectLog(
      id: const Uuid().v4(),
      title: "니드모어 스웨터",
      subtitle: "녹차맛 니드모어",
      pattern: '',
      images: [
        ObjectImage(
            id: const Uuid().v4(),
            image:
                "https://marithe-official.com/web/product/big/202403/e2a7511212556cd4784cb0d4518d5393.jpg")
      ],
      description:
          "이거 뜨는데 7개월이나 걸림 진짜 대박 어려움 그리고 서술형 도안임 그래도 너무너무 이쁘다. 다시 입고 싶은 이유가 뭔지 알겠다. 진짜 너무 존예 볼때마다 행복해져",
      tags: ["탑다운", "새글런", "기성복"],
      needles: ["니트프로 진저 스페셜 3.0mm", "니트프로 진저 스페셜 4.0mm", "니트프로 진저 디럭스 4.0mm"],
      yarns: ["솜솜뜨개 프빌 포레스트 2합"],
      gauges: ["21코 37단"],
      finishedAt: DateTime.now(),
    ),
    ObjectLog(
      id: const Uuid().v4(),
      title: "블랙베리 아란 스웨터",
      subtitle: "",
      pattern: '',
      images: [
        ObjectImage(
            id: const Uuid().v4(),
            image:
                "https://lemonearthchoco.s3.ap-northeast-2.amazonaws.com/myfo/2024/12/%E1%84%91%E1%85%A1%E1%84%85%E1%85%A1%E1%86%BC%E1%84%86%E1%85%A9%E1%84%8C%E1%85%A1%E1%84%80%E1%85%B3%E1%84%85%E1%85%A9%E1%84%86%E1%85%B5%E1%86%BA.png_d9816909-277f-4609-af61-149143e23d1a"),
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
      finishedAt: DateTime.now(),
    ),
    ObjectLog(
      id: const Uuid().v4(),
      title: "dotori hat",
      subtitle: "",
      pattern: '',
      images: [
        ObjectImage(
            id: const Uuid().v4(),
            image:
                "https://image.msscdn.net/thumbnails/images/goods_img/20241029/4571422/4571422_17303584312487_big.jpg?w=1200")
      ],
      description: "도토리 햇",
      tags: ["원통 뜨기"],
      needles: ["니트프로 진저 스페셜 3.0mm", "니트프로 진저 스페셜 4.0mm", "니트프로 진저 디럭스 4.0mm"],
      yarns: ["솜솜뜨개 프빌 포레스트 2합"],
      gauges: [],
      finishedAt: DateTime.now(),
    ),
    ObjectLog(
      id: const Uuid().v4(),
      title: "모헤어 장갑",
      subtitle: "",
      pattern: '',
      images: [
        ObjectImage(
            id: const Uuid().v4(),
            image:
                "https://image.msscdn.net/thumbnails/images/goods_img/20241029/4571422/4571422_17303584312487_big.jpg?w=1200")
      ],
      description: "모헤어 장갑",
      tags: ["장갑 바늘"],
      needles: ["니트프로 진저 스페셜 3.0mm", "니트프로 진저 스페셜 4.0mm", "니트프로 진저 디럭스 4.0mm"],
      yarns: ["솜솜뜨개 프빌 포레스트 2합"],
      gauges: [],
      finishedAt: DateTime.now(),
    ),
  ];

  Future<void> loadLogs({bool forceReset = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? logsJson = prefs.getString(ObjectLog.name);

    if (logsJson != null && !forceReset) {
      final List<dynamic> jsonList = json.decode(logsJson);
      _logs = jsonList.map((json) => ObjectLog.fromJson(json)).toList();
    } else {
      _logs = initialLogs;
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

  Future<void> deleteLog(int index) async {
    _logs.removeAt(index);
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
