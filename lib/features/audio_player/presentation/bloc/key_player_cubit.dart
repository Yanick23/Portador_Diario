import 'package:flutter_bloc/flutter_bloc.dart';

class KeyPlayerCubit extends Cubit<bool> {
  KeyPlayerCubit() : super(false);

  void updatePlayMusicKeyState(bool state) => emit(state);
}
