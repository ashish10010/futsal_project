import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddFutsal extends StatefulWidget {
  const AddFutsal({super.key});

  @override

  _AddFutsalState createState() => _AddFutsalState();
}

class _AddFutsalState extends State<AddFutsal> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController openingTimeController = TextEditingController();
  final TextEditingController closingTimeController = TextEditingController();
  final TextEditingController hourlyPriceController = TextEditingController();
  final TextEditingController monthlyPriceController = TextEditingController();
  final TextEditingController contactController = TextEditingController();

  String? selectedSize;
  List<File?> imageFiles = [];
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Futsal Court", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Section 1: Basic Details
                _buildSectionCard([
                  _buildTextField(
                    controller: nameController,
                    labelText: "Name of Futsal",
                    icon: Icons.sports_soccer,
                  ),
                  _buildTextField(
                    controller: locationController,
                    labelText: "Location",
                    icon: Icons.location_on,
                  ),
                ], title: "Basic Details"),

                // Section 2: Timings and Pricing
                _buildSectionCard([
                  _buildTimePickerField(
                    context,
                    openingTimeController,
                    "Opening Time",
                  ),
                  _buildTimePickerField(
                    context,
                    closingTimeController,
                    "Closing Time",
                  ),
                  // Hourly Price with Nepali Rupees symbol
                  _buildCurrencyField(
                    controller: hourlyPriceController,
                    labelText: "Hourly Price",
                  ),
                  // Monthly Price with Nepali Rupees symbol
                  _buildCurrencyField(
                    controller: monthlyPriceController,
                    labelText: "Monthly Price",
                  ),
                ], title: "Timings & Pricing"),

                // Section 3: Additional Information
                _buildSectionCard([
                  _buildCourtSizeDropdown(),
                ], title: "Additional Information"),

                // Section 4: Image Upload
                _buildSectionCard([
                  _buildImageUploadSection(),
                ], title: "Court Images"),

                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Futsal court details added successfully!",
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text("Add Futsal Court"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children, {required String title}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(icon, color: Colors.green),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCurrencyField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: labelText,
          prefix: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Rs.",
              style: TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildTimePickerField(
    BuildContext context,
    TextEditingController controller,
    String labelText,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: const Icon(Icons.access_time, color: Colors.green),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onTap: () async {
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (pickedTime != null) {
            controller.text = pickedTime.format(context);
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $labelText';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCourtSizeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: "Field Type",
        prefixIcon: const Icon(Icons.scale, color: Colors.green),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      value: selectedSize,
      items: <String>["5A side", "6A side", "7A side"]
          .map(
            (String value) =>
                DropdownMenuItem<String>(value: value, child: Text(value)),
          )
          .toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedSize = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please select a court size";
        }
        return null;
      },
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload Court Images",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: List.generate(3, (index) {
            return GestureDetector(
              onTap: () {
                if (index >= imageFiles.length) {
                  _pickImage(index);
                }
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                  image:
                      (index < imageFiles.length && imageFiles[index] != null)
                          ? DecorationImage(
                              image: FileImage(imageFiles[index]!),
                              fit: BoxFit.cover,
                            )
                          : null,
                ),
                child: (index >= imageFiles.length)
                    ? const Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: Colors.grey,
                      )
                    : Stack(
                        children: [
                          Positioned(
                            top: 8,
                            right: 8,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    imageFiles.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (index < imageFiles.length) {
          imageFiles[index] = File(pickedFile.path);
        } else {
          imageFiles.add(File(pickedFile.path));
        }
      });
    }
  }
}
