import 'package:flutter/material.dart';
import 'package:myfo/components/myfo_cta_button.dart';
import 'package:myfo/components/myfo_text.dart';
import 'package:myfo/models/object_log.dart';
import 'package:myfo/providers/object_log_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ObjectLogAddScreen extends StatefulWidget {
  const ObjectLogAddScreen({Key? key}) : super(key: key);

  @override
  State<ObjectLogAddScreen> createState() => _ObjectLogAddScreenState();
}

class _ObjectLogAddScreenState extends State<ObjectLogAddScreen> {
  final _formKey = GlobalKey<FormState>();

  // 폼 필드 컨트롤러
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _yarnsController = TextEditingController();
  final TextEditingController _needlesController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _gaugesController = TextEditingController();
  final TextEditingController _patternController = TextEditingController();
  DateTime? _finishedAt;

  List<String> _images = [
    "https://marithe-official.com/web/product/big/202403/e2a7511212556cd4784cb0d4518d5393.jpg",
    "https://image.msscdn.net/thumbnails/images/goods_img/20241002/4480313/4480313_17338815224904_big.jpg?w=1200",
    "https://image.msscdn.net/thumbnails/images/goods_img/20241029/4571422/4571422_17303584312487_big.jpg?w=1200",
    "https://marithe-official.com/web/product/big/202403/e2a7511212556cd4784cb0d4518d5393.jpg",
    "https://image.msscdn.net/thumbnails/images/goods_img/20241002/4480313/4480313_17338815224904_big.jpg?w=1200",
    "https://image.msscdn.net/thumbnails/images/goods_img/20241029/4571422/4571422_17303584312487_big.jpg?w=1200"
  ]; // 업로드된 이미지 리스트
  final List<String> _needlesOptions = [
    '3mm',
    '4mm',
    '5mm',
    '6mm',
    '7mm'
  ]; // 선택 가능한 바늘 목록

  final List<String> _yarns = []; // 추가된 실 리스트
  final List<String> _needles = [];

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    _yarnsController.dispose();
    _needlesController.dispose();
    _tagsController.dispose();
    _gaugesController.dispose();
    super.dispose();
  }

  void _showYarnsBottomSheet(BuildContext context) {
    final TextEditingController _yarnInputController = TextEditingController();
    final TextEditingController _amountInputController =
        TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const MyfoText(
                '실 추가하기',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yarnInputController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  alignLabelWithHint: true,
                  label: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: MyfoText(
                      "실 이름",
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountInputController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  alignLabelWithHint: true,
                  label: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: MyfoText(
                      "실 소요량(선택) ex) 300g, 2500m, 8볼",
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final yarn = _yarnInputController.text.trim();
                    final amount = _amountInputController.text.trim();
                    if (yarn.isNotEmpty) {
                      setState(() {
                        if (amount.isNotEmpty) {
                          _yarns.add(yarn + '/' + amount);
                        } else {
                          _yarns.add(yarn); // 실 추가
                        }
                      });
                      Navigator.pop(context); // 바텀 시트 닫기
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text('추가하기'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNeedlesBottomSheet(BuildContext context) {
    final TextEditingController _needleInputController =
        TextEditingController();
    final TextEditingController _sizeInputController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const MyfoText(
                '바늘 추가하기',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _needleInputController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  alignLabelWithHint: true,
                  label: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: MyfoText(
                      "바늘 이름",
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sizeInputController,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  alignLabelWithHint: true,
                  label: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: MyfoText(
                      "바늘 사이즈(선택) ex) 4.0mm, 6호",
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final needle = _needleInputController.text.trim();
                    final size = _sizeInputController.text.trim();
                    if (needle.isNotEmpty) {
                      setState(() {
                        if (size.isNotEmpty) {
                          _needles.add(needle + '/' + size);
                        } else {
                          _needles.add(needle); // 실 추가
                        }
                      });
                      Navigator.pop(context); // 바텀 시트 닫기
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text('추가하기'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveObjectLog(BuildContext context) {
    print("save!");
    if (_formKey.currentState?.validate() ?? false) {
      final provider = Provider.of<ObjectLogProvider>(context, listen: false);

      final newLog = ObjectLog(
        id: const Uuid().v4(),
        title: _titleController.text,
        subtitle: _subtitleController.text,
        description: _descriptionController.text,
        images: _images,
        yarns: _yarns,
        // 저장된 실 리스트 추가
        needles: _needles,
        // 선택된 바늘 저장
        tags: _tagsController.text.split(',').map((e) => e.trim()).toList(),
        gauges: _gaugesController.text.split(',').map((e) => e.trim()).toList(),
        finishedAt: _finishedAt,
      );

      provider.addLog(newLog);
      Navigator.pop(context); // 화면 닫기
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const MyfoText(
            '작품 추가',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const MyfoText('작품 이미지', fontWeight: FontWeight.bold),
                const SizedBox(height: 10),
                // 미리보기 컴포넌트 추가
                SizedBox(
                  height: 100, // 정사각형 칩 높이
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _images.length + 1, // 1은 기본 버튼을 위한 추가 항목
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // 첫 번째 항목은 기본 버튼
                        return Container(
                          margin: const EdgeInsets.only(right: 8), // 간격 조정
                          width: 100,
                          height: 100,
                          child: ElevatedButton(
                            onPressed: () {
                              // 기본 버튼 클릭 시 액션 (예: 이미지 추가하는 동작)
                              // 예시로 이미지 추가하는 동작 넣기
                              print("기본 버튼 클릭됨");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Icon(Icons.add,
                                size: 32, color: Colors.white),
                          ),
                        );
                      } else {
                        // 두 번째 항목부터는 이미지 미리보기
                        final imageUrl =
                            _images[index - 1]; // 이미지 목록은 index 1부터 시작
                        return Container(
                          margin: const EdgeInsets.only(right: 8), // 간격 조정
                          width: 100,
                          height: 100,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                // 모서리 둥글게
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _images.removeAt(index - 1); // 이미지 삭제
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),

                const MyfoText('작품명', fontWeight: FontWeight.bold),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _titleController,
                  label: 'ex) 따뜻한 겨울 스웨터',
                  validator: (value) =>
                      value?.isEmpty ?? true ? '제목을 입력해주세요.' : null,
                ),
                const SizedBox(height: 16),
                const MyfoText('작품 소개', fontWeight: FontWeight.bold),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _subtitleController,
                  label: 'ex) 딸기우유맛 스웨터',
                  validator: (value) =>
                      value?.isEmpty ?? true ? '부제목을 입력해주세요.' : null,
                ),
                const SizedBox(height: 16),
                const MyfoText('패턴', fontWeight: FontWeight.bold),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _patternController,
                  label: 'ex) 자작 도안',
                  validator: (value) =>
                      value?.isEmpty ?? true ? '부제목을 입력해주세요.' : null,
                ),
                const SizedBox(height: 16),
                const MyfoText('설명', fontWeight: FontWeight.bold),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: _descriptionController,
                  label: '이 작품에 대한 이야기를 입력해주세요.',
                  maxLines: 6,
                  validator: (value) =>
                      value?.isEmpty ?? true ? '설명을 입력해주세요.' : null,
                ),
                const SizedBox(height: 16),
                const MyfoText('사용 기법(선택)', fontWeight: FontWeight.bold),
                const SizedBox(height: 10),
                _buildTextField(
                    controller: _tagsController,
                    label: 'ex) 탑 다운, 원통 뜨기(쉼표로 구분)'),
                const SizedBox(height: 16),
                const MyfoText('사용한 실', fontWeight: FontWeight.bold),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._yarns.map((yarn) {
                      return Chip(
                          label: MyfoText(yarn),
                          backgroundColor: Colors.grey[200],
                          deleteIcon: const Icon(Icons.close,
                              size: 16, color: Colors.black),
                          onDeleted: () {
                            setState(() {
                              _yarns.remove(yarn); // 항목 삭제
                            });
                          });
                    }).toList(),
                    IconButton(
                      onPressed: () => _showYarnsBottomSheet(context),
                      icon: const Icon(Icons.add),
                      color: Colors.grey,
                      tooltip: '실 추가하기',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const MyfoText('사용한 바늘', fontWeight: FontWeight.bold),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ..._needles.map((needle) {
                      return Chip(
                          label: MyfoText(needle),
                          backgroundColor: Colors.grey[200],
                          deleteIcon: const Icon(Icons.close,
                              size: 16, color: Colors.black),
                          onDeleted: () {
                            setState(() {
                              _needles.remove(needle); // 항목 삭제
                            });
                          });
                    }).toList(),
                    IconButton(
                      onPressed: () => _showNeedlesBottomSheet(context),
                      icon: const Icon(Icons.add),
                      color: Colors.grey,
                      tooltip: '바늘 추가하기', // 접근성을 위한 툴팁
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        bottomNavigationBar: MyfoCtaButton(
            label: '저장하기', onPressed: () => _saveObjectLog(context)));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 16.0,
        letterSpacing: -0.4,
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        alignLabelWithHint: true,
        label: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: MyfoText(
            label,
            color: Colors.grey,
            fontWeight: FontWeight.normal,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 1.2,
          ),
        ),
      ),
      validator: validator,
      maxLines: maxLines,
    );
  }
}
