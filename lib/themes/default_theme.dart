import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'myfo_colors.dart';

class MyfoDefaultTheme {
  static TextStyle defaultTextStyle = const TextStyle(
      fontFamily: "Paperlogy",
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: MyfoColors.darkDefault);

  static ThemeData defaultTheme = ThemeData(
    // 기본 색상
    primaryColor: MyfoColors.primary,
    primaryColorLight: MyfoColors.primaryLight,
    primaryColorDark: MyfoColors.primaryLight,

    // 올리브색 (primary)
    fontFamily: 'Paperlogy',
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      alignLabelWithHint: true,
      labelStyle: TextStyle(
        fontFamily: "Paperlogy",
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.grey,
      ),
      filled: true,
      fillColor: MyfoColors.secondary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.0),
        borderSide: const BorderSide(
          color: MyfoColors.darkDefault,
          width: 1.2,
        ),
      ),
    ),
    secondaryHeaderColor: const Color(0xFFD3D3D3),
    // 연한 회색 (secondary)

    // 배경색
    scaffoldBackgroundColor: MyfoColors.secondary,

    // 텍스트 스타일
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: MyfoColors.darkDefault, fontSize: 16),
      bodyMedium: TextStyle(color: MyfoColors.darkDefault, fontSize: 14),
      titleLarge: TextStyle(
        color: MyfoColors.darkDefault,
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
        fontFamily: "Paperlogy",
        color: MyfoColors.primary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),

    // 버튼 테마
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: MyfoColors.secondary,
        backgroundColor: MyfoColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        // 버튼 텍스트 색상
        textStyle: const TextStyle(
            fontWeight: FontWeight.bold, color: MyfoColors.secondary),
      ),
    ),

    // 아이콘 테마
    iconTheme: const IconThemeData(
      color: MyfoColors.darkDefault, // 아이콘 기본 색상
    ),

    // DatePicker 테마
    datePickerTheme: DatePickerThemeData(
      backgroundColor: MyfoColors.secondary,
      // DatePicker 배경색
      surfaceTintColor: MyfoColors.secondary,
      headerBackgroundColor: MyfoColors.secondary,
      // 헤더 배경 (올리브색)
      headerForegroundColor: Colors.white,
      // 헤더 텍스트 색상
      dayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return MyfoColors.secondary; // 선택된 날짜 텍스트
        } else if (states.contains(WidgetState.disabled)) {
          return MyfoColors.darkDefault; // 비활성 날짜 텍스트
        }
        return Colors.black; // 기본 텍스트
      }),
      dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return MyfoColors.primary; // 선택된 날짜 배경색 (올리브색)
        }
        return Colors.transparent; // 기본 배경 투명
      }),
      todayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        } else {
          return MyfoColors.darkDefault;
        }
        return Colors.black;
      }),
      todayBorder: BorderSide(color: Colors.transparent),
      todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return MyfoColors.primary;
        }
        return Colors.transparent;
      }),
      // 연도 선택 텍스트
      yearBackgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return MyfoColors.primary; // 연도 선택된 배경 (올리브색)
        }
        return Colors.transparent;
      }),
    ),

    // 탭바 테마
    tabBarTheme: TabBarTheme(
      dividerColor: Colors.transparent,
      labelColor: MyfoColors.primary,
      // 선택된 탭의 색상
      unselectedLabelColor: MyfoColors.primaryLight,
      // 선택되지 않은 탭의 색상
      indicatorColor: Colors.transparent,
      indicator: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: MyfoColors.primary, width: 2), // 올리브색 밑줄
        ),
      ),
    ),

    // Divider 테마
    // dividerColor: const Color(0xFFD3D3D3),
    // 연한 회색 구분선

    // 밝기
    brightness: Brightness.light,

    // 기타 색상
    focusColor: const Color(0xFFD3D3D3),
    // 포커스 색상
    hoverColor: const Color(0xFFD3D3D3), // 호버 색상
  );
}
