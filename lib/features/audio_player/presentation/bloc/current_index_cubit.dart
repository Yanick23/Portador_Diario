import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentIndexCubit extends Cubit<int> {
  CurrentIndexCubit() : super(0);

  void updateCurrentIndexMusic(int index) => emit(index);
}
