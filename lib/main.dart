import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myfo/providers/my_info_provider.dart';
import 'package:myfo/providers/object_log_provider.dart';
import 'package:myfo/screens/myfo_main_screen.dart';
import 'package:myfo/themes/default_theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ObjectLogProvider()..loadLogs(forceReset: false)),
        ChangeNotifierProvider(create: (context) => MyInfoProvider()..loadMyInfo())
      ],
      child: MaterialApp(
        title: "myfo",
        debugShowCheckedModeBanner: false,
        theme: MyfoDefaultTheme.defaultTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
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
}
