import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/my_info.dart';

class MyInfoProvider extends ChangeNotifier {
  MyInfo _myInfo = MyInfo(themeName: 'Default', fontFamily: 'Roboto', language: 'ko');

  MyInfo get myInfo => _myInfo;

  Future<void> loadMyInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      // 앱 최초 실행 시 기본 데이터 저장
      String deviceLanguage = _getDeviceLanguage();
      _myInfo = MyInfo(themeName: 'Default', fontFamily: 'Paperlogy', language: deviceLanguage);
      await saveMyInfo(_myInfo);
      await prefs.setBool('isFirstLaunch', false); // 첫 실행 표시 설정
    } else {
      // 기존 데이터 로드
      final themeName = prefs.getString('themeName') ?? 'Default';
      final fontFamily = prefs.getString('fontFamily') ?? 'Paperlogy';
      _myInfo = MyInfo(themeName: themeName, fontFamily: fontFamily, language: 'ko');
    }

    notifyListeners();
  }

  void setLanguage(String newLanguage) {
    if (!['en', 'ko'].contains(newLanguage)) return;
    _myInfo = MyInfo(
      themeName: _myInfo.themeName,
      fontFamily: _myInfo.fontFamily,
      language: newLanguage,
    );
    notifyListeners();
  }

  Future<void> saveMyInfo(MyInfo myInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeName', myInfo.themeName);
    await prefs.setString('fontFamily', myInfo.fontFamily);
    await prefs.setString('language', myInfo.language);
    _myInfo = myInfo;
    notifyListeners();
  }

  void updateTheme(String themeName) {
    saveMyInfo(MyInfo(themeName: themeName, fontFamily: _myInfo.fontFamily, language: _myInfo.language));
  }

  void updateFontFamily(String fontFamily) {
    saveMyInfo(MyInfo(themeName: _myInfo.themeName, fontFamily: fontFamily, language: _myInfo.language));
  }

  String _getDeviceLanguage() {
    Locale deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    String languageCode = deviceLocale.languageCode;

    // 지원하는 언어 목록에 없으면 기본값 'en' 사용
    return ['en', 'ko'].contains(languageCode) ? languageCode : 'en';
  }
}
