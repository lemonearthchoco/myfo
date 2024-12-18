import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
        theme: ThemeData(
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            // AppBar 투명 설정
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            // 그림자 제거
            iconTheme: IconThemeData(color: Colors.black),
            // 아이콘 색상
            titleTextStyle: TextStyle(
              // 제목 텍스트 스타일
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            systemOverlayStyle: SystemUiOverlayStyle.dark,
          ),
        ),
        home: const MyfoMainScreen(),
      ),
    );
  }
}