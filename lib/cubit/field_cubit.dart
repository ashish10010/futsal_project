import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/src/features/futsal/data/models/field_model.dart';
import 'package:logger/logger.dart';

import '../service/field_service.dart';

part 'field_state.dart';

class FieldCubit extends Cubit<FieldState> {
  
  final _logger = Logger();

  final FieldService fieldService;

  FieldCubit(this.fieldService) : super(FieldInitial());

  // Fetch all fields
  Future<void> fetchAllFields() async {
    try {
      emit(FieldLoading());
      final fields = await fieldService.fetchAllFields();
      emit(FieldSuccess(fields));
    } catch (e) {
      emit(FieldFailure(e.toString()));
    }
  }

//fetch field by id
  FieldModel getFieldById(String futsalId) {
    if (state is FieldSuccess) {
      final fields = (state as FieldSuccess).fields;
      return fields.firstWhere(
        (field) => field.id == futsalId,
        orElse: () =>
            FieldModel.empty(), // Provide a fallback in case ID is not found
      );
    } else {
      throw Exception('Fields are not loaded yet.');
    }
  }

  // Fetch fields added by the logged-in owner
  Future<void> fetchFieldsByOwner() async {
    try {
      emit(FieldLoading());
      final userId = await fieldService.getUserId();
      if (userId != null) {
        final fields = await fieldService.fetchAllFields();
        final ownerFields =
            fields.where((field) => field.userId == userId).toList();
        emit(FieldSuccess(ownerFields));
      } else {
        throw Exception("User ID not found.");
      }
    } catch (e) {
      emit(FieldFailure(e.toString()));
    }
  }

  // Add a new field
  Future<void> addField(FieldModel field) async {
    _logger.e('This is working:::::::::');
    try {
      emit(FieldLoading());
      _logger.e('This tryyy is working:::::::::');

      final userid = await fieldService.getUserId();

      await fieldService.addFutsal(
        name: field.name,
        email: field.email,
        location: field.location,
        cardImg: field.cardImg,
        img1: field.img1,
        img2: field.img2,
        hourlyPrice: field.hourlyPrice,
        monthlyPrice: field.monthlyPrice,
        contact: field.contact,
        courtSize: field.courtSize,
        userId: userid!,
      );
      await fetchAllFields();
    } catch (e) {
      emit(FieldFailure(e.toString()));
    }
  }

  // Update a field
  Future<void> updateField(String fieldId, FieldModel updatedField) async {
    try {
      emit(FieldLoading());
      await fieldService.updateFutsalById(fieldId, updatedField);
      await fetchAllFields(); // Refresh fields after updating
    } catch (e) {
      emit(FieldFailure(e.toString()));
    }
  }

  // Delete a field
  Future<void> deleteField(String fieldId) async {
    try {
      emit(FieldLoading());
      await fieldService.deleteFutsal(fieldId);
      await fetchAllFields(); // Refresh fields after deleting
    } catch (e) {
      emit(FieldFailure(e.toString()));
    }
  }
}
