import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfo/components/myfo_text.dart';
import 'package:myfo/providers/object_log_provider.dart';
import 'package:myfo/models/object_log.dart';
import 'package:myfo/screens/myfo/myfo_add_screen.dart';
import 'package:myfo/screens/myfo/myfo_detail_screen.dart';
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
            expandedHeight: 20.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Text(
                "my finished objects",
                style: GoogleFonts.jost(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // GridView를 SliverList로 대체
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 0.0),
            sliver: Consumer<ObjectLogProvider>(
              builder: (context, provider, child) {
                final logs = provider.logs;

                if (logs.isEmpty) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: MyfoText(
                        "새로운 작품을 등록해보세요!",
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                }

                // 그룹화: finishedAt 기준으로 {year}-{month}로 분리
                final groupedLogs = _groupLogsByMonth(logs);

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final String groupKey = groupedLogs.keys.elementAt(index);
                      final List<ObjectLog> groupLogs = groupedLogs[groupKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
                            child: Text(groupKey, // 예: "2024-12"
                                style: GoogleFonts.jost(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                )),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: groupLogs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // 한 줄에 2개씩
                              crossAxisSpacing: 0.0, // 항목 간 가로 간격
                              mainAxisSpacing: 0.0, // 항목 간 세로 간격
                              childAspectRatio: 1, // 정사각형 비율
                            ),
                            itemBuilder: (context, gridIndex) {
                              final log = groupLogs[gridIndex];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MyfoDetailScreen(objectLogId: log.id),
                                    ),
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              // borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
                                              child: log.images.isNotEmpty
                                                  ? Image.network(
                                                      log.images[0]
                                                          .image, // 대표 이미지
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Image.file(
                                                            File(log.images[0]
                                                                .image),
                                                            // 대표 이미지
                                                            fit: BoxFit.cover);
                                                      },
                                                    )
                                                  : const Icon(
                                                      Icons.image_not_supported,
                                                      size: 50),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(  // 좋아요 기능 나중에 추가
                                      bottom: 8,
                                      right: 8,
                                      child: IconButton(
                                        onPressed: () => {print("좋아요!")},
                                        icon: Icon(CupertinoIcons.heart, color: Colors.grey[200]),
                                        iconSize: 28,
                                        padding: const EdgeInsets.all(0),
                                        constraints: const BoxConstraints(),
                                        splashRadius: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                    childCount: groupedLogs.keys.length,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ObjectLogAddScreen(),
            ),
          );
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }

  // Helper function: Logs를 {year}-{month}로 그룹화
  Map<String, List<ObjectLog>> _groupLogsByMonth(List<ObjectLog> logs) {
    final Map<String, List<ObjectLog>> groupedLogs = {};

    for (final log in logs) {
      String yearMonth = "";
      if (log.finishedAt == null) {
        yearMonth = "unknown";
      } else {
        yearMonth = '${log.finishedAt!.year}-${log.finishedAt!.month.toString().padLeft(2, '0')}';
      }

      if (!groupedLogs.containsKey(yearMonth)) {
        groupedLogs[yearMonth] = [];
      }

      groupedLogs[yearMonth]!.add(log);
    }

    return groupedLogs;
  }
}
