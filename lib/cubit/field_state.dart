part of 'field_cubit.dart';

abstract class FieldState extends Equatable {
  const FieldState();

  @override
  List<Object?> get props => [];
}

class FieldInitial extends FieldState {}

class FieldLoading extends FieldState {}

class FieldSuccess extends FieldState {
  final List<FieldModel> fields;

  const FieldSuccess(this.fields);

  @override
  List<Object?> get props => [fields];
}

class FieldFailure extends FieldState {
  final String error;

  const FieldFailure(this.error);

  @override
  List<Object?> get props => [error];
}
