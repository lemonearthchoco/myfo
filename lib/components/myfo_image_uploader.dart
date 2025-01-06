import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class MyfoImageUploader extends StatefulWidget {
  @override
  _MyfoImageUploader createState() => _MyfoImageUploader();
}

class _MyfoImageUploader extends State<MyfoImageUploader> {
  File? _selectedImage;
  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();

  // 이미지 선택 함수
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // 이미지 업로드 함수
  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final uri = Uri.parse("https://example.com/api/upload"); // 가상 API
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath(
          'image',
          _selectedImage!.path,
        ));

      final response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지 업로드 성공!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('이미지 업로드 실패!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_selectedImage != null)
          Image.file(
            _selectedImage!,
            height: 200,
          )
        else
          Text('이미지를 선택하세요'),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _pickImage,
          child: Text('이미지 선택'),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isUploading ? null : _uploadImage,
          child: _isUploading
              ? CircularProgressIndicator(color: Colors.white)
              : Text('이미지 업로드'),
        ),
      ],
    );
  }
}
