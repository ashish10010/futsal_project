import 'package:flutter_bloc/flutter_bloc.dart';

class RatingCubit extends Cubit<double> {
  RatingCubit() : super(0.0); // Default rating is 0.0

  void setRating(double rating) => emit(rating);
}
