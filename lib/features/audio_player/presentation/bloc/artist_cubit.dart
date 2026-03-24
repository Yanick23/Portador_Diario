import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';

class ArtistCubit extends Cubit<Artist?> {
  ArtistCubit() : super(null);

  void setArtist(Artist artist) => emit(artist);
}
