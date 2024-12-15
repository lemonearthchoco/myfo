import 'dart:convert';
import 'package:flutter/cupertino.dart';
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
        images: ["https://marithe-official.com/web/product/big/202403/e2a7511212556cd4784cb0d4518d5393.jpg"],
        description: "이거 뜨는데 7개월이나 걸림 진짜 대박 어려움 그리고 서술형 도안임 그래도 너무너무 이쁘다. 다시 입고 싶은 이유가 뭔지 알겠다. 진짜 너무 존예 볼때마다 행복해져",
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
        images: ["https://image.msscdn.net/thumbnails/images/goods_img/20241002/4480313/4480313_17338815224904_big.jpg?w=1200"],
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
        images: ["https://image.msscdn.net/thumbnails/images/goods_img/20241029/4571422/4571422_17303584312487_big.jpg?w=1200"],
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
        images: ["https://image.msscdn.net/thumbnails/images/goods_img/20231102/3677601/3677601_16988766430252_big.jpg?w=1200"],
        description: "모헤어 장갑",
        tags: ["장갑 바늘"],
        needles: ["니트프로 진저 스페셜 3.0mm", "니트프로 진저 스페셜 4.0mm", "니트프로 진저 디럭스 4.0mm"],
        yarns: ["솜솜뜨개 프빌 포레스트 2합"],
        gauges: [],
      finishedAt: DateTime.now(),),
    ObjectLog(
        id: const Uuid().v4(),
        title: "니드모어 스웨터",
        subtitle: "",
        images: ["https://image.msscdn.net/thumbnails/images/goods_img/20220831/2757373/2757373_1_big.jpg?w=1200"],
        description: "탑다운으로 뜨는 니트",
        tags: ["탑다운", "새글런", "기성복"],
        needles: ["니트프로 진저 스페셜 3.0mm", "니트프로 진저 스페셜 4.0mm", "니트프로 진저 디럭스 4.0mm"],
        yarns: ["솜솜뜨개 프빌 포레스트 2합"],
        gauges: [],
      finishedAt: DateTime.now(),),
    ObjectLog(
        id: const Uuid().v4(),
        title: "블랙베리 아란 스웨터",
        subtitle: "",
        images: ["https://image.msscdn.net/thumbnails/images/goods_img/20240926/4467546/4467546_17302780808309_big.jpg?w=1200"],
        description: "만약 너무 길면 어쩌지 만약 너무 길면 어떡하지 만약 너무 긴텍스트면 어떻게 나올까요",
        tags: ["바텀업"],
        needles: ["니트프로 진저 스페셜 3.0mm", "니트프로 진저 스페셜 4.0mm", "니트프로 진저 디럭스 4.0mm"],
        yarns: ["솜솜뜨개 프빌 포레스트 2합"],
        gauges: [],
      finishedAt: DateTime.now(),),
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
    final String logsJson = json.encode(_logs.map((log) => log.toJson()).toList());
    await prefs.setString(ObjectLog.name, logsJson);
  }
}
