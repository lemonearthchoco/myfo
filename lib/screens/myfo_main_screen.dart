import 'package:flutter/material.dart';
import 'package:myfo/screens/myfo_list_screen.dart';

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
      // appBar: AppBar(
      //   title: const KnitText(
      //       text: 'KnitSchedule', fontSize: 24, fontWeight: FontWeight.bold),
      // ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MyfoListScreen(), // 첫 번째 탭에서 DiaryListScreen으로 이동
          Center(child: Text('Profile Screen')), // 두 번째 탭 화면
          Center(child: Text('Profile Screen')), // 세 번째 탭 화면
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 16.0), // 하단 여백 추가
        child: TabBar(
          dividerColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home)),
            Tab(icon: Icon(Icons.settings)),
            Tab(icon: Icon(Icons.person)),
          ],
        ),
      ),
    );
  }
}
