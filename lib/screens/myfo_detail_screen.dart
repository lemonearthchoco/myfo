import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:myfo/components/myfo_divider.dart';
import 'package:myfo/components/myfo_tag.dart';
import 'package:myfo/components/myfo_text.dart';
import 'package:myfo/models/object_image.dart';
import 'package:myfo/models/object_log.dart';
import 'package:myfo/providers/object_log_provider.dart';
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
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))],
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
                _buildTagSection(log.tags),
                const MyfoDivider(),
                _buildYarnSection(log.yarns),
                const MyfoDivider(),
                _buildNeedleSection(log.needles),
                const MyfoDivider(),
                _buildGaugeSection(log.gauges),
                const MyfoDivider(),
                _buildDescriptionSection(log.description),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyfoText(
            log.title,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 6),
          log.subtitle.isNotEmpty
              ? MyfoText(log.subtitle, fontSize: 16)
              : Container(),
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
              color: Colors.grey,
              fontSize: 12,
            ),
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
            "설명",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 12,
            ),
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
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyfoText(title,
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
          const SizedBox(height: 10),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.75),
              child: MyfoText(item),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1.0,
      thickness: 3.5,
      color: Color.fromARGB(232, 232, 232, 232),
    );
  }
}
