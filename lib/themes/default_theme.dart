import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfo/themes/myfo_custom_colors.dart';
import 'package:myfo/themes/myfo_tag_decoration.dart';

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
    dividerColor: MyfoColors.secondaryDark,

    extensions: <ThemeExtension<dynamic>>[
      MyfoCustomColors(),
      MyfoTagDecoration(
          defaultBoxDecoration: BoxDecoration(
        color: MyfoColors.beigeLight,
        borderRadius: BorderRadius.circular(20), // 둥근 모서리
        border: Border.all(color: MyfoColors.beigeLight), // 테두리
      )),
    ],

    fontFamily: 'Paperlogy',
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: MyfoColors.darkDefaultLight, // 커서 색상
      selectionColor: MyfoColors.beigeLight, // 드래그 선택 영역 색상
      selectionHandleColor: MyfoColors.beigeLight, // 선택 핸들 색상
    ),
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
    popupMenuTheme: PopupMenuThemeData(
      position: PopupMenuPosition.under,
      color: MyfoColors.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      iconColor: MyfoColors.darkDefault
    ),
    chipTheme: ChipThemeData(
        backgroundColor: MyfoColors.beigeLight,
        selectedColor: MyfoColors.beigeLight,
        deleteIconColor: MyfoColors.darkDefault,
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide.none,
        ),
        showCheckmark: false,
        labelStyle: TextStyle(
            color: MyfoColors.darkDefault,
            fontFamily: "Paperlogy",
            fontSize: 14)),
    // 배경색
    dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(fontSize: 16, color: MyfoColors.darkDefault),
      backgroundColor: MyfoColors.secondary,
    ),
    scaffoldBackgroundColor: MyfoColors.secondary,

    // 텍스트 스타일
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: MyfoColors.darkDefault, fontSize: 16),
      bodyMedium: TextStyle(color: MyfoColors.darkDefault, fontSize: 14),
      labelLarge:  TextStyle(color: MyfoColors.secondary, fontSize: 14),
      titleLarge: TextStyle(
        color: MyfoColors.darkDefault,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: MyfoColors.primary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      )
    ),

    // AppBar 테마
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: MyfoColors.darkDefault),
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
          color: MyfoColors.secondary,
            fontFamily: 'Paperlogy', fontWeight: FontWeight.w600),
      ),
    ),

    // 아이콘 테마
    iconTheme: const IconThemeData(
      color: MyfoColors.darkDefault, // 아이콘 기본 색상
    ),

    // DatePicker 테마
    datePickerTheme: DatePickerThemeData(
      backgroundColor: MyfoColors.secondary,
      surfaceTintColor: MyfoColors.secondary,
      headerBackgroundColor: MyfoColors.secondary,
      headerForegroundColor: Colors.white,
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
          return MyfoColors.primary;
        }
        return Colors.transparent;
      }),
      todayForegroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return MyfoColors.secondary;
        } else {
          return MyfoColors.darkDefault;
        }
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
      indicatorColor: Colors.transparent
    ),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.resolveWith((states) {
          return TextStyle(
              color: MyfoColors.darkDefault,
              fontFamily: 'Paperlogy', fontWeight: FontWeight.w600
          );
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          return MyfoColors.darkDefault; // 기본 텍스트 색상
        }),
        overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
          // 클릭 시 잔상 색상
          return states.contains(WidgetState.pressed)
              ? MyfoColors.beigeLight
              : null;
        }),
      )
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
