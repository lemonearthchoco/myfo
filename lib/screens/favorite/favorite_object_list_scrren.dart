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

class FavoriteObjectListScreen extends StatelessWidget {
  const FavoriteObjectListScreen({Key? key}) : super(key: key);

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
                title: Text("FAVORITE",
                    // style: GoogleFonts.jost(
                    //   fontSize: 20,
                    //   fontWeight: FontWeight.bold,
                    // )),
                    style: TextStyle(
                        fontFamily: 'Paperlogy',
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold))),
          ),
          // GridView를 SliverList로 대체
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            sliver: Consumer<ObjectLogProvider>(
              builder: (context, provider, child) {
                final logs = provider.favoriteLogs; // 좋아요 누른 objects

                if (logs.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.heart,
                              size: 36,
                              color: Theme.of(context).primaryColorLight),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("좋아하는 작품을 모아보세요!",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorLight)
                              // fontWeight: FontWeight.bold,
                              ),
                        ],
                      ),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MyfoDetailScreen(objectLogId: log.id)),
                          );
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
                                          log.images[0].image, // 대표 이미지
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.file(
                                                File(log
                                                    .images[0].image), // 대표 이미지
                                                fit: BoxFit.cover);
                                          },
                                        )
                                      : const Icon(Icons.image_not_supported,
                                          size: 50),
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
    );
  }
}
