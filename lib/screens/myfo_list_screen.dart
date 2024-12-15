import 'package:flutter/material.dart';
import 'package:myfo/components/myfo_text.dart';
import 'package:myfo/providers/object_log_provider.dart';
import 'package:myfo/models/object_log.dart';
import 'package:provider/provider.dart';

class MyfoListScreen extends StatelessWidget {
  const MyfoListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar 설정
          SliverAppBar(
            expandedHeight: 20.0, // AppBar의 확장 높이
            pinned: true, // 스크롤 시 AppBar를 고정
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: const MyfoText(
                text: "myFo",
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // GridView를 SliverList로 대체
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            sliver: Consumer<ObjectLogProvider>(
              builder: (context, provider, child) {
                final logs = provider.logs;

                if (logs.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text('새로운 작품을 등록해보세요!'),
                    ),
                  );
                }

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 한 줄에 두 개씩 배치
                    crossAxisSpacing: 0.0, // 항목 간 가로 간격
                    mainAxisSpacing: 0.0, // 항목 간 세로 간격
                    // childAspectRatio: 0.8, // 항목의 가로:세로 비율
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final ObjectLog log = logs[index];

                      return GestureDetector(
                        onTap: () {
                          // 상세 페이지 이동 (필요 시 구현)
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ObjectLogDetailScreen(log: log),
                          //   ),
                          // );
                        },
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  // borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
                                  child: log.images.isNotEmpty
                                      ? Image.network(
                                    log.images[0], // 대표 이미지
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.broken_image, size: 50);
                                    },
                                  )
                                      : const Icon(Icons.image_not_supported, size: 50),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: logs.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add screen으로 이동 (필요 시 구현)
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ObjectLogAddScreen(),
          //   ),
          // );
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
