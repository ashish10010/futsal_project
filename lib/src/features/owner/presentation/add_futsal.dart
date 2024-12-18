import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:futsal_booking_app/service/auth_service.dart';
import 'package:futsal_booking_app/service/field_service.dart';
import '../../../core/constants/images.dart';

class AddFutsal extends StatefulWidget {
  const AddFutsal({super.key});

  @override
  State<AddFutsal> createState() => _AddFutsalState();
}

class _AddFutsalState extends State<AddFutsal> {
  final _formKey = GlobalKey<FormState>();
  final Logger _logger = Logger();

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController hourlyPriceController = TextEditingController();
  final TextEditingController monthlyPriceController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  String? selectedCourtSize;
  bool isLoading = false;

  final FieldService _fieldService = FieldService();
  final ImagePicker _imagePicker = ImagePicker();
  List<File> selectedImages = [];

  /// Pick multiple images
  Future<void> _pickImages() async {
    try {
      final List<XFile>? images = await _imagePicker.pickMultiImage();

      if (images != null && images.isNotEmpty) {
        setState(() {
          selectedImages = images.map((e) => File(e.path)).toList();
        });
        _logger.d("Images selected: ${selectedImages.map((e) => e.path)}");
      } else {
        _logger.w("No images were selected.");
      }
    } catch (e) {
      _logger.e("Error picking images: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking images: $e")),
      );
    }
  }

 
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && selectedCourtSize != null) {
      setState(() => isLoading = true);

      try {
        final userId = await AuthService().getUserId();
        if (userId == null) throw Exception("User not authenticated.");

        await _fieldService.addFutsal(
          name: nameController.text,
          email: emailController.text,
          location: locationController.text,
          hourlyPrice: hourlyPriceController.text,
          monthlyPrice: monthlyPriceController.text,
          contact: contactController.text,
          courtSize: selectedCourtSize!,
          userId: userId,
          cardImg: addfutsalcardimgUrl,
          img1: addfutsalImg1Url,
          img2: addFutsalImg2Url,
        );

        _logger.i("Futsal added successfully!");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Futsal Court Added Successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        _logger.e("Error adding futsal: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() => isLoading = false);
      }
    } else {
      _logger.w("Form validation failed or court size not selected.");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Futsal Court"),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(nameController, "Futsal Name"),
                    _buildTextField(emailController, "Email"),
                    _buildTextField(locationController, "Location"),
                    _buildTextField(hourlyPriceController, "Hourly Price",
                        isNumeric: true),
                    _buildTextField(monthlyPriceController, "Monthly Price",
                        isNumeric: true),
                    _buildTextField(contactController, "Contact",
                        isNumeric: true),
                    _buildCourtSizeDropdown(),
                    const SizedBox(height: 20),
                    _buildImagePickerSection(),
                    const SizedBox(height: 20),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return "Please enter $label";
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCourtSizeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Court Size",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      value: selectedCourtSize,
      items: ["5A Side", "6A Side", "7A Side"]
          .map((size) => DropdownMenuItem(value: size, child: Text(size)))
          .toList(),
      onChanged: (value) => setState(() => selectedCourtSize = value),
      validator: (value) => value == null ? "Please select a court size" : null,
    );
  }

  Widget _buildImagePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pick Images",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            GestureDetector(
              onTap: _pickImages,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    const Icon(Icons.add_a_photo, size: 40, color: Colors.teal),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedImages
                    .map(
                      (image) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          image,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          "Add Futsal Court",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
