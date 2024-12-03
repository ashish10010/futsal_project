
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/field_model.dart';
import '../service/field_service.dart';



part 'field_state.dart';

class FieldCubit extends Cubit<FieldState> {
  final FieldService _fieldService;

  FieldCubit(this._fieldService) : super(FieldInitial());

  void fetchFields() async {
    try {
      emit(FieldLoading());
      List<FieldModel> fields = await _fieldService.fetchFields();
      emit(FieldSuccess(fields));
    } catch (e) {
      emit(FieldFailure(e.toString()));
    }
  }
}
