import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/field_service.dart';
import '../src/features/futsal/data/models/field_model.dart';

part 'field_state.dart';

class FieldCubit extends Cubit<FieldState> {
  final FieldService _fieldService;

  FieldCubit(this._fieldService) : super(FieldInitial());

  /// Fetch all fields
  Future<void> fetchFields() async {
    try {
      emit(FieldLoading());
      final fields = await _fieldService.fetchAllFields();
      emit(FieldSuccess(fields));
    } catch (e) {
      emit(FieldFailure(e.toString()));
    }
  }

  /// Get a futsal field by ID
  Future<void> getFutsalById(String futsalId) async {
    try {
      emit(FieldLoading());
      final field = await _fieldService.getFutsalById(futsalId);
      emit(SingleFieldSuccess(field));
    } catch (e) {
      emit(FieldFailure(e.toString()));
    }
  }

  /// Add a new futsal field
  Future<void> addFutsal(FieldModel field) async {
    try {
      emit(FieldLoading());
      await _fieldService.addFutsal(field);
      emit(FieldOperationSuccess('Futsal added successfully.'));
    } catch (e) {
      emit(FieldFailure(e.toString()));
    }
  }

  /// Update a futsal field by ID
  Future<void> updateFutsal(String futsalId, FieldModel updatedField) async {
    try {
      emit(FieldLoading());
      await _fieldService.updateFutsalById(futsalId, updatedField);
      emit(FieldOperationSuccess('Futsal updated successfully.'));
    } catch (e) {
      emit(FieldFailure(e.toString()));
    }
  }

  /// Delete a futsal field by ID
  Future<void> deleteFutsal(String futsalId) async {
    try {
      emit(FieldLoading());
      await _fieldService.deleteFutsal(futsalId);
      emit(FieldOperationSuccess('Futsal deleted successfully.'));
    } catch (e) {
      emit(FieldFailure(e.toString()));
    }
  }
}
