import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myfo/screens/myfo_main_screen.dart';
import 'package:myfo/providers/object_log_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ObjectLogProvider()..loadLogs(forceReset: true),
      child: MaterialApp(
        title: "myfo",
        theme: buildThemeData(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate, // Cupertino 위젯 로컬라이제이션 지원
        ],
        supportedLocales: const [
          Locale('ko'), // 한국어 지원
          Locale('en'), // 영어 지원 (기본)
        ],
        home: const MyfoMainScreen(),
      ),
    );
  }

  ThemeData buildThemeData() {
    return ThemeData(
      // 기본 색상
      primaryColor: const Color(0xFF808000),
      // 올리브색 (primary)
      secondaryHeaderColor: const Color(0xFFD3D3D3),
      // 연한 회색 (secondary)

      // 배경색
      scaffoldBackgroundColor: Colors.white,

      // 텍스트 스타일
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
        bodyMedium: TextStyle(color: Colors.black, fontSize: 14),
        titleLarge: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // AppBar 테마
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // 버튼 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF808000),
          // 버튼 텍스트 색상
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      // 아이콘 테마
      iconTheme: const IconThemeData(
        color: Colors.black, // 아이콘 기본 색상
      ),

      // DatePicker 테마
      datePickerTheme: DatePickerThemeData(
        backgroundColor: Colors.white,
        // DatePicker 배경색
        surfaceTintColor: Colors.white,
        headerBackgroundColor: const Color(0xFF808000),
        // 헤더 배경 (올리브색)
        headerForegroundColor: Colors.white,
        // 헤더 텍스트 색상
        dayForegroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white; // 선택된 날짜 텍스트
          } else if (states.contains(MaterialState.disabled)) {
            return Colors.grey; // 비활성 날짜 텍스트
          }
          return Colors.black; // 기본 텍스트
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF808000); // 선택된 날짜 배경색 (올리브색)
          }
          return Colors.transparent; // 기본 배경 투명
        }),
        todayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white; // 연도 선택된 배경 (올리브색)
          } else {
            return Colors.black;
          }
          return Colors.black;
        }),
        todayBorder: BorderSide(color: Colors.transparent),
        todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF808000); // 연도 선택된 배경 (올리브색)
          }
          return Colors.transparent;
        }),
        // 연도 선택 텍스트
        yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const Color(0xFF808000); // 연도 선택된 배경 (올리브색)
          }
          return Colors.transparent;
        }),
      ),

      // 탭바 테마
      tabBarTheme: TabBarTheme(
        labelColor: const Color(0xFF808000), // 선택된 탭의 색상
        unselectedLabelColor: Colors.black, // 선택되지 않은 탭의 색상
        indicator: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFF808000), width: 2), // 올리브색 밑줄
          ),
        ),
      ),

      // Divider 테마
      dividerColor: const Color(0xFFD3D3D3),
      // 연한 회색 구분선

      // 밝기
      brightness: Brightness.light,

      // 기타 색상
      focusColor: const Color(0xFFD3D3D3),
      // 포커스 색상
      hoverColor: const Color(0xFFD3D3D3), // 호버 색상
    );
  }
}
