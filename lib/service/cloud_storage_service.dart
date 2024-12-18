import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudStorageService {
  final String bucketName = "quicksal-da7b9.appspot.com"; // Replace with your bucket name
  final String baseUrl = "https://firebasestorage.googleapis.com/v0/b/";

  /// Upload an image to Firebase Storage and return the download URL
  Future<String> uploadImage(File file, String filePath) async {
    try {
      // Firebase endpoint for uploading files
      final uri = Uri.parse('$baseUrl$bucketName/o?name=$filePath');

      // Create a multipart request
      final request = http.MultipartRequest("POST", uri);

      // Attach file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'file', // Field name expected by Firebase
        file.path,
      ));

      // Send the request
      final response = await request.send();

      // Check the response status
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);

        // Build the public download URL
        final downloadUrl =
            "https://firebasestorage.googleapis.com/v0/b/$bucketName/o/${Uri.encodeComponent(filePath)}?alt=media";
        
        return downloadUrl;
      } else {
        throw Exception('Failed to upload image: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }
}
