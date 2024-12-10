part of 'field_cubit.dart';

abstract class FieldState {}

class FieldInitial extends FieldState {}

class FieldLoading extends FieldState {}

class FieldSuccess extends FieldState {
  final List<FieldModel> fields;

  FieldSuccess(this.fields);
}

class SingleFieldSuccess extends FieldState {
  final FieldModel field;

  SingleFieldSuccess(this.field);
}

class FieldFailure extends FieldState {
  final String error;

  FieldFailure(this.error);
}

class FieldOperationSuccess extends FieldState {
  final String message;

  FieldOperationSuccess(this.message);
}
