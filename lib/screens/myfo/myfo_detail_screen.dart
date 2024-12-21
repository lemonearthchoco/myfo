import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:myfo/components/myfo_divider.dart';
import 'package:myfo/components/myfo_tag.dart';
import 'package:myfo/components/myfo_text.dart';
import 'package:myfo/components/myfo_toast.dart';
import 'package:myfo/models/object_image.dart';
import 'package:myfo/models/object_log.dart';
import 'package:myfo/providers/object_log_provider.dart';
import 'package:myfo/screens/myfo/myfo_add_screen.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyfoDetailScreen extends StatefulWidget {
  final String objectLogId;

  const MyfoDetailScreen({Key? key, required this.objectLogId})
      : super(key: key);

  @override
  State<MyfoDetailScreen> createState() => _MyfoDetailScreenState();
}

class _MyfoDetailScreenState extends State<MyfoDetailScreen> {
  int _currentIndex = 0;
  bool isAvailable = true;
  bool isFavorite = false;
  late FToast fToast;

  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  void _showToast(context, String message, MessageLevel level) {
    fToast.showToast(
        child: MyfoToast(message: message),
        toastDuration: const Duration(seconds: 1));
  }

  void _deleteObjectLog(BuildContext context) {
    final provider = Provider.of<ObjectLogProvider>(context, listen: false);
    setState(() {
      this.isAvailable = false;
    });
    Navigator.pop(context);
    provider.deleteLog(widget.objectLogId).then((_) => {
          // TODO: 토스트 메시지
          _showToast(context, "삭제 성공", MessageLevel.SUCCESS)
        }); // Provider에서 삭제
  }

  @override
  Widget build(BuildContext context) {
    if (!isAvailable) {
      return Scaffold(
        body: Center(child: Container()),
      );
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.ellipsis_vertical),
            onPressed: () {
              // CupertinoActionSheet 표시
              showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoActionSheet(
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(context); // ActionSheet 닫기
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ObjectLogAddScreen(
                                objectLogId: widget.objectLogId,
                              ),
                            ),
                          );
                        },
                        child: const Text('수정하기'),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () {
                          Navigator.pop(context); // 상세 화면 닫기
                          _deleteObjectLog(context);
                        },
                        isDestructiveAction: true, // 파괴적 작업 스타일 (빨간색)
                        child: const Text('삭제하기'),
                      ),
                    ],
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.pop(context); // ActionSheet 닫기
                      },
                      child: const Text(
                        '취소',
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<ObjectLogProvider>(
        builder: (context, provider, child) {
          // ObjectLog 데이터를 ID로 찾기
          final ObjectLog? log =
              provider.logs.firstWhere((log) => log.id == widget.objectLogId);

          if (log == null) {
            return const Center(
              child: Text('해당 데이터를 찾을 수 없습니다.'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이미지 섹션
                _buildImageSection(log.images),
                _buildTitleSection(log),
                const MyfoDivider(),
                _buildFoSection(log.finishedAt),
                const MyfoDivider(),
                _buildPatternSection(log.pattern),
                const MyfoDivider(),
                _buildTagSection(log.tags),
                const MyfoDivider(),
                _buildYarnSection(log.yarns),
                _buildNeedleSection(log.needles),
                _buildGaugeSection(log.gauges),
                const MyfoDivider(),
                _buildDescriptionSection(log.description),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSection(List<ObjectImage> images) {
    return Stack(
      children: [
        SizedBox(
          height: 400,
          width: double.infinity,
          child: images.isNotEmpty
              ? CarouselSlider.builder(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    height: 400,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    autoPlay: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index, realIndex) {
                    return SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: Image.network(
                        images[index].image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.broken_image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              : const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
        ),
        if (images.isNotEmpty)
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedSmoothIndicator(
                activeIndex: _currentIndex,
                count: images.length,
                effect: ScrollingDotsEffect(
                  dotWidth: 8.0,
                  dotHeight: 8.0,
                  activeDotColor: Colors.white,
                  dotColor: Colors.grey,
                ),
                onDotClicked: (index) {
                  _carouselController.animateToPage(index);
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTitleSection(ObjectLog log) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 타이틀과 서브타이틀
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )
                ),
                const SizedBox(height: 6),
                if (log.subtitle.isNotEmpty)
                  Text(log.subtitle, style: TextStyle(
                    fontSize: 14
                  )),
              ],
            ),
          ),
          // 좋아요 버튼
          Consumer<ObjectLogProvider>(
            builder: (context, provider, child) {
              final isFavorite = log.isFavorite;
              return IconButton(
                icon: Icon(
                  isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  if (isFavorite) {
                    provider.unlikeLog(log.id); // 좋아요 취소
                    // _showToast(context, "좋아요를 취소했습니다.", MessageLevel.SUCCESS);
                  } else {
                    provider.likeLog(log.id); // 좋아요 설정
                    // _showToast(context, "좋아요를 추가했습니다.", MessageLevel.SUCCESS);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTagSection(List<String> tags) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "태그",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            )
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: tags
                .map(
                  (tag) => MyfoTag(tag),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFoSection(DateTime? finishedAt) {
    if (finishedAt != null) {
      return _buildListSection("FO", [DateFormat('yyyy-MM-dd').format(finishedAt)]);
    }
    return _buildListSection("FO", ["2024-12-20"]);
  }

  Widget _buildPatternSection(String pattern) {
    return _buildListSection("패턴", pattern.isNotEmpty ? [pattern] : []);
  }
  Widget _buildNeedleSection(List<String> needles) {
    return _buildListSection("사용 바늘", needles);
  }

  Widget _buildYarnSection(List<String> yarns) {
    return _buildListSection("실", yarns);
  }

  Widget _buildGaugeSection(List<String> gauges) {
    return _buildListSection("게이지", gauges);
  }

  Widget _buildDescriptionSection(String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "설명"
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection(String title, List<String> items) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            if (items.isNotEmpty)
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.75),
                  child: Text(
                    item,
                  ),
                ),
              )
            else
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10),
                child: Text('-'),
              )
          ],
        ));
  }
}
