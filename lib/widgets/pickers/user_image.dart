import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker(this.imagePickFn);

  final void Function(String pickedImagePath) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  PickedFile? _pickedImage;

  Future<void> _pickImage() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _pickedImage = pickedFile;
        widget.imagePickFn(_pickedImage!.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage != null ? FileImage(File(_pickedImage!.path)) : null,
          radius: 40,
        ),
        TextButton(
          child: Text('Select Image'),
          onPressed: _pickImage,
        ),
      ],
    );
  }
}
