import 'package:flutter_bloc/flutter_bloc.dart';

class ImagePlayListAndAlbumCubit extends Cubit<String?> {
  ImagePlayListAndAlbumCubit() : super(null);

  void updateImageUrl(String url) => emit(url);
}
