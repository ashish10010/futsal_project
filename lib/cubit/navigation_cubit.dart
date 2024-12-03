import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0); // Initial tab is 0 (Home)

  void updateTab(int tabIndex) => emit(tabIndex);
}
