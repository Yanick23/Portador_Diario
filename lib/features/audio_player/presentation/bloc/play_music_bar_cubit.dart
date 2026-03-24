import 'package:flutter_bloc/flutter_bloc.dart';

class PlayMusicBarCubit extends Cubit<bool> {
  PlayMusicBarCubit() : super(false);

  void updatePlayMusicBarState(bool state) => emit(state);
}
