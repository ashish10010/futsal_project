import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  
  Future<List<File>> pickMultipleImages(int count) async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null) {
      
      return pickedFiles.take(count).map((file) => File(file.path)).toList();
    } else {
      return []; 
    }
  }
}
