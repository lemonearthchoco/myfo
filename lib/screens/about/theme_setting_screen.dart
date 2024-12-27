import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeSettingScreen extends StatefulWidget {
  const ThemeSettingScreen({Key? key}) : super(key: key);

  @override
  State<ThemeSettingScreen> createState() => _ThemeSettingScreen();
}

class _ThemeSettingScreen extends State<ThemeSettingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("테마 설정"),
          iconTheme: const IconThemeData(color: Colors.black),
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(child: Text("업데이트 예정입니다.")));
  }
}
