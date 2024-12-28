import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myfo/models/object_log.dart';
import 'package:myfo/providers/object_log_provider.dart';
import 'package:myfo/screens/myfo/myfo_add_screen.dart';
import 'package:myfo/screens/myfo/myfo_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../themes/myfo_colors.dart';

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
                "FINISHED",
                style: TextStyle(
                    fontFamily: "Paperlogy",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
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
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.square_on_square,
                              size: 36,
                              color: Theme.of(context).primaryColorLight),
                          SizedBox(
                            height: 10,
                          ),
                          Text("내 작품을 등록해보세요!",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorLight)),
                        ],
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
                                style: TextStyle(
                                    fontFamily: 'Paperlogy',
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16)),
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
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          return child; // 이미지 로드 완료
                                                        }
                                                        return Shimmer
                                                            .fromColors(
                                                          baseColor: MyfoColors
                                                              .beigeLight,
                                                          highlightColor:
                                                              MyfoColors
                                                                  .beigeDark,
                                                          child: Container(
                                                            height: 200,
                                                            color: MyfoColors
                                                                .beigeLight,
                                                          ),
                                                        );
                                                      },
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Container(
                                                            color: MyfoColors
                                                                .beigeLight,
                                                            child: Icon(
                                                                CupertinoIcons
                                                                    .wifi_slash,
                                                                size: 36,
                                                                color: MyfoColors
                                                                    .primaryLight));
                                                      },
                                                    )
                                                  : Image.asset(
                                                      'assets/images/image_placeholder.png', // 대표 이미지
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      // 좋아요 기능 나중에 추가
                                      bottom: 8,
                                      right: 8,
                                      child: IconButton(
                                        onPressed: () => {
                                          if (log.isFavorite)
                                            {provider.unlikeLog(log.id)}
                                          else
                                            {provider.likeLog(log.id)}
                                        },
                                        icon: log.isFavorite
                                            ? Icon(CupertinoIcons.heart_fill,
                                                color: Colors.red)
                                            : Icon(CupertinoIcons.heart,
                                                color: Colors.grey[200]),
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
        backgroundColor: MyfoColors.primary,
        foregroundColor: MyfoColors.secondary,
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: MyfoColors.beigeLight,
      highlightColor: MyfoColors.beigeLight!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, List<ObjectLog>> _groupLogsByMonth(List<ObjectLog> logs) {
    final Map<String, List<ObjectLog>> groupedLogs = {};

    for (final log in logs) {
      String year = "";
      if (log.finishedAt == null) {
        year = "unknown";
      } else {
        // yearMonth =
        //     '${log.finishedAt!.year}-${log.finishedAt!.month.toString().padLeft(2, '0')}';
        year = '${log.finishedAt!.year}';
      }

      if (!groupedLogs.containsKey(year)) {
        groupedLogs[year] = [];
      }

      groupedLogs[year]!.add(log);
    }

    return groupedLogs;
  }
}
