import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:myfo/components/myfo_cta_button.dart';
import 'package:myfo/components/myfo_label.dart';
import 'package:myfo/components/myfo_toast.dart';
import 'package:myfo/models/exceptions/image_upload_fail_exception.dart';
import 'package:myfo/models/object_image.dart';
import 'package:myfo/models/object_log.dart';
import 'package:myfo/models/object_pattern.dart';
import 'package:myfo/providers/object_log_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../themes/myfo_colors.dart';

class ObjectLogAddScreen extends StatefulWidget {
  final String? objectLogId;

  const ObjectLogAddScreen({Key? key, this.objectLogId}) : super(key: key);

  @override
  State<ObjectLogAddScreen> createState() => _ObjectLogAddScreenState();
}

class _ObjectLogAddScreenState extends State<ObjectLogAddScreen> {
  final _formKey = GlobalKey<FormState>();
  late FToast fToast;

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

  final ImagePicker _picker = ImagePicker();

  List<File> _selectedImages = [];
  List<String> _uploadedImageUrls = [];
  bool _isUploading = false;

  final List<String> _yarns = []; // 추가된 실 리스트
  final List<String> _needles = [];

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    if (widget.objectLogId != null) {
      _loadExistingLog();
    }
  }

  void _showToast(context, String message, MessageLevel level) {
    fToast.showToast(
        child: MyfoToast(message: message, level: level),
        toastDuration: const Duration(seconds: 1));
  }

  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null) {
      if (_uploadedImageUrls.length + images.length > 5) {
        _showToast(context, "최대 5개까지 업로드 가능합니다.", MessageLevel.ERROR);
      } else {
        _selectedImages = images.map((image) => File(image.path)).toList();
        await _uploadAllImages();
      }
    }
  }

  Future<void> _loadExistingLog() async {
    final provider = Provider.of<ObjectLogProvider>(context, listen: false);
    final existingLog = await provider.getLogById(widget.objectLogId!);

    if (existingLog != null) {
      setState(() {
        _titleController.text = existingLog.title ?? '';
        _subtitleController.text = existingLog.subtitle ?? '';
        _descriptionController.text = existingLog.description ?? '';
        _patternController.text = existingLog.pattern.content ?? '';
        _uploadedImageUrls =
            existingLog.images.map((img) => img.image).toList();
        _yarns.addAll(existingLog.yarns);
        _needles.addAll(existingLog.needles);
        _tagsController.text = existingLog.tags.join(', ');
        _gaugesController.text = existingLog.gauges.join(', ');
        _finishedAt = existingLog.finishedAt;
      });
    }
  }

  Future<void> _uploadImage(File image) async {
    String baseUrl = dotenv.get('IMAGE_SERVER_BASE_URL');
    String apiUrl = '$baseUrl/myfo/images'; // Mock API URL

    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decodedData = jsonDecode(responseData);
        setState(() {
          _uploadedImageUrls.add(decodedData['imageUrl']); // 서버에서 반환된 이미지 URL
        });
      } else {
        throw ImageUploadFailException("이미지 업로드 실패!");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _uploadAllImages() async {
    setState(() {
      _isUploading = true;
    });
    try {
      for (var image in _selectedImages) {
        await _uploadImage(image);
      }
      if (_selectedImages.isNotEmpty) {
        _showToast(
            context,
            AppLocalizations.of(context)!.myfo_image_upload_success_message,
            MessageLevel.SUCCESS);
      }
    } catch (e) {
      _showToast(
          context,
          AppLocalizations.of(context)!.myfo_image_upload_fail_message,
          MessageLevel.ERROR);
    }

    setState(() {
      _isUploading = false;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _descriptionController.dispose();
    _yarnsController.dispose();
    _needlesController.dispose();
    _tagsController.dispose();
    _gaugesController.dispose();
    _patternController.dispose();
    super.dispose();
  }

  void _showYarnsBottomSheet(BuildContext context) {
    final TextEditingController _yarnInputController = TextEditingController();
    final TextEditingController _amountInputController =
        TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: MyfoColors.secondary,
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
              Text(
                  AppLocalizations.of(context)!
                      .myfo_yarn_input_bottom_sheet_title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  )),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yarnInputController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .myfo_yarn_name_input_placeholder),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountInputController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .myfo_yarn_amount_input_placeholder),
                // "실 소요량(선택) ex) 300g, 2500m, 8볼",
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
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                      AppLocalizations.of(context)!.common_add_button_label),
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
      backgroundColor: MyfoColors.secondary,
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
              Text(AppLocalizations.of(context)!.myfo_needle_input_bottom_sheet_title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  )),
              const SizedBox(height: 16),
              TextFormField(
                controller: _needleInputController,
                decoration: InputDecoration(labelText: AppLocalizations.of(context)!.myfo_needle_name_input_placeholder),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _sizeInputController,
                // 바늘 사이즈(선택) ex) 4.0mm, 6호
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.myfo_needle_size_input_placeholder),
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
                            _needles.add(needle);
                          }
                        });
                        Navigator.pop(context); // 바텀 시트 닫기
                      }
                    },
                    child: Text(
                        AppLocalizations.of(context)!.common_add_button_label)),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDatePickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: MyfoColors.secondary,
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
              const Text('완성일',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 16),
              CalendarDatePicker(
                initialDate: _finishedAt ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2030),
                onDateChanged: (DateTime date) {
                  setState(() {
                    _finishedAt = date;
                  });
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: MyfoCtaButton(
                  label: '선택 완료',
                  onPressed: () {
                    Navigator.pop(context); // BottomSheet 닫기
                  },
                  // style: ElevatedButton.styleFrom(
                  //   backgroundColor: Colors.black,
                  //   foregroundColor: Colors.white,
                  //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                  // ),
                  // child: const Text('완료'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: () => _showDatePickerBottomSheet(context),
      child: InputDecorator(
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          alignLabelWithHint: true,
          filled: true,
          // fillColor: MyfoColors.secondary,
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
        child: Text(
          _finishedAt != null
              ? '${_finishedAt!.year}-${_finishedAt!.month.toString().padLeft(2, '0')}-${_finishedAt!.day.toString().padLeft(2, '0')}'
              : AppLocalizations.of(context)!
                  .myfo_finished_at_input_placeholder,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color:
                  _finishedAt != null ? MyfoColors.darkDefault : Colors.grey),
        ),
      ),
    );
  }

  void _saveObjectLog(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = Provider.of<ObjectLogProvider>(context, listen: false);

      final log = ObjectLog(
        id: widget.objectLogId ?? const Uuid().v4(),
        title: _titleController.text,
        subtitle: _subtitleController.text,
        pattern: ObjectPattern(type: 'url', content: _patternController.text),
        description: _descriptionController.text,
        images: _uploadedImageUrls
            .map((image) => ObjectImage(id: const Uuid().v4(), image: image))
            .toList(),
        yarns: _yarns,
        needles: _needles,
        tags: _tagsController.text
            .split(',')
            .map((e) => e.trim())
            .where((t) => t.isNotEmpty)
            .toList(),
        gauges:
            [_gaugesController.text.trim()].where((t) => t.isNotEmpty).toList(),
        finishedAt: _finishedAt,
      );

      if (widget.objectLogId != null) {
        // 수정 모드
        provider.updateLog(widget.objectLogId!, log);
        _showToast(context, "저장 완료", MessageLevel.SUCCESS);
      } else {
        // 추가 모드
        provider.addLog(log);
        _showToast(context, "저장 완료", MessageLevel.SUCCESS);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.objectLogId == null
                ? AppLocalizations.of(context)!.myfo_add_title
                : AppLocalizations.of(context)!.myfo_edit_title,
            // fontWeight: FontWeight.bold,
          ),
          leading: IconButton(
            icon: Icon(CupertinoIcons.back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus(); // 키보드 닫기
            },
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  MyfoLabel(
                      label:
                          '${AppLocalizations.of(context)!.myfo_image_input_label} (${_uploadedImageUrls.length}/5)'),
                  const SizedBox(height: 10),
                  // 미리보기 컴포넌트 추가
                  SizedBox(
                    height: 100, // 정사각형 칩 높이
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _uploadedImageUrls.length + 1,
                      // 1은 기본 버튼을 위한 추가 항목
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // 첫 번째 항목은 기본 버튼
                          return Container(
                            margin: const EdgeInsets.only(right: 8), // 간격 조정
                            width: 100,
                            height: 100,
                            child: ElevatedButton(
                              onPressed: _pickImages,
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: MyfoColors.beigeLight,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  shadowColor: Colors.transparent),
                              child: _isUploading
                                  ? CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Icon(CupertinoIcons.add,
                                      size: 32, color: MyfoColors.beigeDark),
                            ),
                          );
                        } else {
                          // 두 번째 항목부터는 이미지 미리보기
                          final imagePath = _uploadedImageUrls[
                              index - 1]; // 이미지 목록은 index 1부터 시작
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
                                    imagePath,
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
                                        _uploadedImageUrls
                                            .removeAt(index - 1); // 이미지 삭제
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
                  const SizedBox(height: 16),
                  MyfoLabel(
                      label:
                          AppLocalizations.of(context)!.myfo_title_input_label),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _titleController,
                    label: AppLocalizations.of(context)!
                        .myfo_title_input_placeholder,
                    validator: (value) =>
                        value?.isEmpty ?? true ? '작품명을 입력해주세요.' : null,
                  ),
                  const SizedBox(height: 16),
                  MyfoLabel(
                      label: AppLocalizations.of(context)!
                          .myfo_description_input_label),
                  const SizedBox(height: 10),
                  _buildTextField(
                      controller: _subtitleController,
                      label: AppLocalizations.of(context)!
                          .myfo_description_input_placeholder),
                  const SizedBox(height: 16),
                  MyfoLabel(
                      label: AppLocalizations.of(context)!
                          .myfo_finished_at_input_label,
                      optional: true),
                  const SizedBox(height: 10),
                  _buildDateField(),
                  const SizedBox(height: 16),
                  MyfoLabel(
                    label:
                        AppLocalizations.of(context)!.myfo_pattern_input_label,
                    optional: false,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _patternController,
                    label: AppLocalizations.of(context)!
                        .myfo_pattern_input_placeholder,
                  ),
                  const SizedBox(height: 16),
                  MyfoLabel(
                    label: AppLocalizations.of(context)!
                        .myfo_techniques_input_label,
                    optional: false,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                      controller: _tagsController,
                      label: AppLocalizations.of(context)!
                          .myfo_techniques_input_placeholder),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(AppLocalizations.of(context)!.myfo_yarn_input_title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      InkWell(
                        onTap: () => _showYarnsBottomSheet(context),
                        borderRadius: BorderRadius.circular(20), // 클릭 영역 모양
                        child: Padding(
                          padding: const EdgeInsets.all(6), // 원하는 만큼 패딩
                          child: const Icon(CupertinoIcons.add, size: 16),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._yarns.map((yarn) {
                        return Chip(
                            label: Text(yarn),
                            side: BorderSide.none,
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              setState(() {
                                _yarns.remove(yarn); // 항목 삭제
                              });
                            });
                      }).toList(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                          AppLocalizations.of(context)!.myfo_needle_input_title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14)),
                      InkWell(
                        onTap: () => _showNeedlesBottomSheet(context),
                        borderRadius: BorderRadius.circular(20), // 클릭 영역 모양
                        child: Padding(
                          padding: const EdgeInsets.all(6), // 원하는 만큼 패딩
                          child: const Icon(CupertinoIcons.add, size: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ..._needles.map((needle) {
                        return Chip(
                            label: Text(needle),
                            side: BorderSide.none,
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              setState(() {
                                _needles.remove(needle); // 항목 삭제
                              });
                            });
                      }).toList(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  MyfoLabel(
                      label:
                          AppLocalizations.of(context)!.myfo_gauge_input_title),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _gaugesController,
                    label: AppLocalizations.of(context)!
                        .myfo_gauge_input_placeholder,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  MyfoLabel(
                      label: AppLocalizations.of(context)!
                          .myfo_review_input_title),
                  const SizedBox(height: 10),
                  _buildTextField(
                      controller: _descriptionController,
                      label: AppLocalizations.of(context)!
                          .myfo_review_input_placeholder,
                      maxLines: 6),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: MyfoCtaButton(
            label: AppLocalizations.of(context)!.myfo_save_button_label,
            onPressed: () => _saveObjectLog(context)));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: validator,
        maxLines: maxLines);
  }
}
