import 'package:flutter_bloc/flutter_bloc.dart';

class TypeReproducerCubit extends Cubit<Object?> {
  TypeReproducerCubit() : super(null);

  void updateTypeReproducerState(Object object) => emit(object);
}
