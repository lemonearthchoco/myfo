import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfo/screens/about/about_screen.dart';
import 'package:myfo/screens/favorite/favorite_object_list_scrren.dart';
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
          dividerColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              return states.contains(WidgetState.focused) ? null : Colors.transparent;
            },
          ),
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(CupertinoIcons.folder_open)),
            Tab(icon: Icon(CupertinoIcons.heart)),
            Tab(icon: Icon(CupertinoIcons.info)),
          ],
        ),
      ),
    );
  }
}
