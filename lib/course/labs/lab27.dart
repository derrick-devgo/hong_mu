import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Lab 27：相機 + 相簿
/// 使用官方套件 image_picker：
/// - ImageSource.camera  → 開相機拍照
/// - ImageSource.gallery → 從相簿選照片
///
/// 記得在 pubspec.yaml 加入：
///   image_picker: ^1.1.2
///
/// iOS 需在 ios/Runner/Info.plist 加入：
///   <key>NSCameraUsageDescription</key>
///   <string>需要相機權限以拍照</string>
///   <key>NSPhotoLibraryUsageDescription</key>
///   <string>需要相簿權限以選取照片</string>
///
/// Android 通常 image_picker 已自動處理，不需手動加權限。
class ImagePickerDemo extends StatefulWidget {
  const ImagePickerDemo({super.key});

  @override
  State<ImagePickerDemo> createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<ImagePickerDemo> {
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedFile;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: source,
        imageQuality: 80, // 壓縮品質 0-100
        maxWidth: 1920,   // 最大寬度（可選）
      );
      if (file == null) return; // 使用者取消
      setState(() {
        _pickedFile = file;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('取得照片失敗：$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 27 - 相機 & 相簿')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 顯示選到的圖片
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _pickedFile == null
                    ? const Center(child: Text('尚未選取照片'))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_pickedFile!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            // 操作按鈕
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('拍照'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('相簿'),
                  ),
                ),
              ],
            ),
            if (_pickedFile != null) ...[
              const SizedBox(height: 8),
              Text(
                '路徑：${_pickedFile!.path}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
