import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File?) parentPickImage;
  ImagePickerWidget({required this.parentPickImage});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  Uint8List? _imageBytes;
  final ImagePicker picker = ImagePicker();

  Future<void> getImage(ImageSource imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    widget.parentPickImage(pickedFile == null ? null : File(pickedFile.path));
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPhotoArea(),
        const SizedBox(height: 8),
        _buildButton(),
      ],
    );
  }

  Widget _buildPhotoArea() {
    return _imageBytes != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: SizedBox(
              width: double.infinity,
              height: 250,
              child: Image.memory(
                _imageBytes!,
                fit: BoxFit.cover,
              ),
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Container(
              width: double.infinity,
              height: 250,
              color: Colors.grey,
            ),
          );
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.camera_alt),
          onPressed: () => getImage(ImageSource.camera),
          color: Colors.black,
        ),
        const SizedBox(width: 2),
        IconButton(
          icon: const Icon(Icons.collections),
          onPressed: () => getImage(ImageSource.gallery),
          color: Colors.black,
        ),
      ],
    );
  }
}
