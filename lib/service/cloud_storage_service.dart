import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http;

class CloudStorageService {
  final String bucketName = "quicksal-da7b9.appspot.com"; // Correct bucket name
  final String baseUrl = "https://firebasestorage.googleapis.com/v0/b";

  /// Upload an image to Firebase Storage and return the download URL
  Future<String> uploadImage(File file, String filePath) async {
    try {
      final uri = Uri.parse("$baseUrl/$bucketName/o?name=$filePath");
      final request = http.MultipartRequest("POST", uri);

      // Attach the image file
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: http.MediaType('image', 'jpeg'), // Ensure correct content type
      ));

      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);

        // Generate download URL
        final downloadUrl =
            "https://firebasestorage.googleapis.com/v0/b/$bucketName/o/${Uri.encodeComponent(filePath)}?alt=media&token=${jsonResponse['downloadTokens']}";
        return downloadUrl;
      } else {
        throw Exception('Failed to upload image: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}
