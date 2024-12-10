import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/src/features/futsal/data/models/field_model.dart';

import '../service/field_service.dart';

part 'field_state.dart';

class FieldCubit extends Cubit<FieldState> {
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
        orElse: () => FieldModel.empty(), // Provide a fallback in case ID is not found
      );
    } else {
      throw Exception('Fields are not loaded yet.');
    }
  }

  // Fetch fields added by the logged-in owner
  Future<void> fetchFieldsByOwner() async {
    try {
      emit(FieldLoading());
      final fields = await fieldService.fetchAllFields(); // Assuming all fields are fetched and filtered by `userId`
      emit(FieldSuccess(fields.where((field) => field.userId == 'YOUR_USER_ID').toList()));
    } catch (e) {
      emit(FieldFailure(e.toString()));
    }
  }

  // Add a new field
  Future<void> addField(FieldModel field) async {
    try {
      emit(FieldLoading());
      await fieldService.addFutsal(field);
      await fetchAllFields(); // Refresh fields after adding
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
