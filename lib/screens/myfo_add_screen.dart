import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfo/components/myfo_text.dart';
import 'package:provider/provider.dart';
import 'package:myfo/models/object_log.dart';
import 'package:myfo/providers/object_log_provider.dart';
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
  DateTime? _finishedAt;

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

  void _saveObjectLog(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = Provider.of<ObjectLogProvider>(context, listen: false);

      final newLog = ObjectLog(
        id: const Uuid().v4(),
        title: _titleController.text,
        subtitle: _subtitleController.text,
        description: _descriptionController.text,
        images: ["https://image.msscdn.net/thumbnails/images/goods_img/20241029/4571422/4571422_17303584312487_big.jpg?w=1200"],
        yarns: _yarnsController.text.split(',').map((e) => e.trim()).toList(),
        needles: _needlesController.text.split(',').map((e) => e.trim()).toList(),
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
          'add object',
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
                label: '제목',
                validator: (value) =>
                value?.isEmpty ?? true ? '제목을 입력해주세요.' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _subtitleController,
                label: '부제목',
                validator: (value) =>
                value?.isEmpty ?? true ? '부제목을 입력해주세요.' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: '설명',
                maxLines: 3,
                validator: (value) =>
                value?.isEmpty ?? true ? '설명을 입력해주세요.' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _yarnsController,
                label: '사용한 실 (쉼표로 구분)',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _needlesController,
                label: '사용한 바늘 (쉼표로 구분)',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _tagsController,
                label: '태그 (쉼표로 구분)',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _gaugesController,
                label: '게이지 (쉼표로 구분)',
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(10.0),
            // ),
          ),
          onPressed: () => _saveObjectLog(context),
          child: const Text(
            '저장하기',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
        floatingLabelBehavior:FloatingLabelBehavior.always,
        label: MyfoText(label, fontWeight: FontWeight.bold,),
        filled: true,
        fillColor: Colors.grey[200],
        // border: UnderlineInputBorder(
        //   // borderRadius: BorderRadius.circular(12.0),
        //   // borderSide: BorderSide(color: Colors.black),
        // ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      validator: validator,
      maxLines: maxLines,
    );
  }
}
