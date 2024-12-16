import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfo/components/myfo_cta_button.dart';
import 'package:myfo/components/myfo_image_uploader.dart';
import 'package:myfo/components/myfo_text.dart';
import 'package:provider/provider.dart';
import 'package:myfo/models/object_log.dart';
import 'package:myfo/providers/object_log_provider.dart';
import 'package:uuid/uuid.dart';

import 'myfo_add_photo_screen.dart'; // MyfoAddPhotoScreen import

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
  DateTime? _finishedAt;

  List<String> _images = []; // 업로드된 이미지 리스트
  final List<String> _needlesOptions = ['3mm', '4mm', '5mm', '6mm', '7mm']; // 선택 가능한 바늘 목록
  final List<String> _selectedNeedles = []; // 선택된 바늘
  final List<String> _yarns = []; // 추가된 실 리스트

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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                decoration: const InputDecoration(
                  labelText: '실 이름',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final yarn = _yarnInputController.text.trim();
                    if (yarn.isNotEmpty) {
                      setState(() {
                        _yarns.add(yarn); // 실 추가
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
    if (_formKey.currentState?.validate() ?? false) {
      final provider = Provider.of<ObjectLogProvider>(context, listen: false);

      final newLog = ObjectLog(
        id: const Uuid().v4(),
        title: _titleController.text,
        subtitle: _subtitleController.text,
        description: _descriptionController.text,
        images: _images,
        yarns: _yarns, // 저장된 실 리스트 추가
        needles: _selectedNeedles, // 선택된 바늘 저장
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
              _buildTextField(
                controller: _titleController,
                label: '작품명',
                validator: (value) =>
                value?.isEmpty ?? true ? '제목을 입력해주세요.' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _subtitleController,
                label: '작품 소개',
                validator: (value) =>
                value?.isEmpty ?? true ? '부제목을 입력해주세요.' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: '이 작품에 대한 이야기를 입력해주세요.',
                maxLines: 6,
                validator: (value) =>
                value?.isEmpty ?? true ? '설명을 입력해주세요.' : null,
              ),
              const SizedBox(height: 16),
              const MyfoText('사용한 실', fontWeight: FontWeight.bold),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _yarns.map((yarn) {
                  return Chip(
                    label: Text(yarn),
                    backgroundColor: Colors.grey[200],
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _showYarnsBottomSheet(context),
                child: const MyfoText('실 추가하기'),
              ),
              const SizedBox(height: 10),
              // 추가된 실 리스트 표시

              const SizedBox(height: 16),
              const MyfoText('사용한 바늘 사이즈', fontWeight: FontWeight.bold),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _needlesOptions.map((needle) {
                  final isSelected = _selectedNeedles.contains(needle); // 선택 여부 확인
                  return GestureDetector(
                    // onTap: () => _toggleNeedleSelection(needle), // 카드 클릭 시 선택 상태 변경
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color:
                        isSelected ? Colors.black : Colors.white, // 선택 여부에 따라 색상 변경
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.grey, // 테두리 색상 변경
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        needle,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black, // 텍스트 색상 변경
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyfoCtaButton(label: '저장하기', onPressed: () => _saveObjectLog(context))
    );
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
