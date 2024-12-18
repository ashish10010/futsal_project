import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:futsal_booking_app/service/auth_service.dart';
import 'package:futsal_booking_app/service/cloud_storage_service.dart';
import 'package:futsal_booking_app/service/image_picker_service.dart';
import 'package:futsal_booking_app/cubit/field_cubit.dart';
import 'package:futsal_booking_app/src/features/futsal/data/models/field_model.dart';

class AddFutsal extends StatefulWidget {
  const AddFutsal({super.key});

  @override
  State<AddFutsal> createState() => _AddFutsalState();
}

class _AddFutsalState extends State<AddFutsal> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController hourlyPriceController = TextEditingController();
  final TextEditingController monthlyPriceController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  String? selectedCourtSize;
  final ImagePickerService _imagePickerService = ImagePickerService();
  final CloudStorageService _cloudStorageService = CloudStorageService();

  List<File> selectedImages = [];
  bool isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() &&
        selectedCourtSize != null &&
        selectedImages.length == 3) {
      setState(() => isLoading = true);

      try {
        final userId = await AuthService().getUserId();
        if (userId == null) throw Exception("User not authenticated.");

        // Upload images to Cloud Storage
        final cardImageUrl = await _cloudStorageService.uploadImage(
          selectedImages[0],
          "futsal_images/card_${DateTime.now()}",
        );
        final carouselImageUrl1 = await _cloudStorageService.uploadImage(
          selectedImages[1],
          "futsal_images/carousel1_${DateTime.now()}",
          
        );
        final carouselImageUrl2 = await _cloudStorageService.uploadImage(
          selectedImages[2],
          "futsal_images/carousel2_${DateTime.now()}",
        );

        final newFutsal = FieldModel(
          id: '',
          email: '',
          name: nameController.text,
          location: locationController.text,
          hourlyPrice: hourlyPriceController.text,
          monthlyPrice: monthlyPriceController.text,
          courtSize: selectedCourtSize!,
          contact: contactController.text,
          cardImg: cardImageUrl,
          img1: carouselImageUrl1,
          img2: carouselImageUrl2,
          userId: userId,
        );

        await context.read<FieldCubit>().addField(newFutsal);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Futsal Court Added Successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() => isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Please fill all fields and select 3 images!')),
      );
    }
  }

  Future<void> _pickImages() async {
    final images = await _imagePickerService.pickMultipleImages(3);
    setState(() {
      selectedImages = images.map((e) => File(e.path)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Futsal Court"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(nameController, "Futsal Name"),
                    _buildTextField(locationController, "Location"),
                    _buildTextField(hourlyPriceController, "Hourly Price",
                        isNumeric: true),
                    _buildTextField(monthlyPriceController, "Monthly Price",
                        isNumeric: true),
                    _buildTextField(contactController, "Contact",
                        isNumeric: true),
                    _buildCourtSizeDropdown(),
                    const SizedBox(height: 16),
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
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Enter $label" : null,
      ),
    );
  }

  Widget _buildCourtSizeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Court Size",
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      value: selectedCourtSize,
      items: ["5A Side", "6A Side", "7A Side"]
          .map((size) => DropdownMenuItem(value: size, child: Text(size)))
          .toList(),
      onChanged: (value) => setState(() => selectedCourtSize = value),
    );
  }

  Widget _buildImagePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Pick 3 Images",
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
                child: const Icon(
                  Icons.add_a_photo,
                  size: 40,
                  color: Colors.teal,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Wrap(
              spacing: 10,
              children: selectedImages
                  .map((image) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          image,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.teal,
      ),
      child: const Text(
        "Add Futsal Court",
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
