import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfo/screens/about/about_screen.dart';
import 'package:myfo/screens/favorite/favorite_object_list_screen.dart';
import 'package:myfo/screens/myfo/myfo_list_screen.dart';

class MyfoMainScreen extends StatefulWidget {
  const MyfoMainScreen({Key? key}) : super(key: key);

  @override
  State<MyfoMainScreen> createState() => _MyfoMainScreen();
}

class _MyfoMainScreen extends State<MyfoMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 탭 개수 설정
    _tabController.addListener(() {
      setState(() {}); // 탭 변경 시 UI 업데이트
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        children: const [
          MyfoListScreen(), // 첫 번째 탭에서 DiaryListScreen으로 이동
          FavoriteObjectListScreen(), // 두 번째 탭 화면
          AboutScreen(), // 세 번째 탭 화면
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 24.0), // 하단 여백 추가
        child: TabBar(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              return states.contains(WidgetState.focused)
                  ? null
                  : Colors.transparent;
            },
          ),
          controller: _tabController,
          tabs: [
            Tab(icon: _tabController.index == 0 ?  Icon(CupertinoIcons.square_fill_on_square_fill) : Icon(CupertinoIcons.square_on_square)),
            Tab(icon: _tabController.index == 1 ?  Icon(CupertinoIcons.heart_fill) : Icon(CupertinoIcons.heart)),
            Tab(icon: _tabController.index == 2 ?  Icon(CupertinoIcons.person_fill) : Icon(CupertinoIcons.person)),
          ],
        ),
      ),
    );
  }
}
