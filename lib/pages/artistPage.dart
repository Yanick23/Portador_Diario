import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spoti_stream_music/models/modelsData.dart' as models;
import 'package:spoti_stream_music/providers/artistsProvider.dart';
import 'package:spoti_stream_music/servicies/searchService.dart';
import 'package:spotify/spotify.dart' as spoti;

class ArtistPage extends StatefulWidget {
  const ArtistPage();

  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  late ScrollController scrollController;
  late double? imageSize;
  bool showTopBar = false;

  List<spoti.Track> top10Tracks = [];
  models.Artists? artist;

  final SearchService _searchService = SearchService(
      'cac81364fb3c4160815b48280446612e', 'd12dd157d54342759fe55340b8354e80');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    artist = Provider.of<ArtistProvider>(context).artista;
    _fetchTopTracks();
  }

  void _fetchTopTracks() async {
    if (artist != null) {
      List<spoti.Track>? tracks =
          await _searchService.top10TrackArtist(artist!.id!);
      setState(() {
        if (tracks != null) {
          top10Tracks = tracks;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    imageSize = 200;

    scrollController.addListener(() {
      if (scrollController.offset > imageSize!) {
        setState(() {
          showTopBar = true;
        });
      } else {
        setState(() {
          showTopBar = false;
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (artist == null) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height - 350,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(artist!.images!.first!.url!),
                fit: BoxFit.fill,
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 30,
                  color: Color.fromARGB(255, 66, 65, 65),
                ),
              ],
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 15, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 290,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0),
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0),
                          const Color.fromARGB(255, 45, 44, 44)
                              .withOpacity(0.9),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 190),
                        Container(
                          width: double.infinity,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 2,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Text(
                                  artist!.name!,
                                  style: const TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 20),
                    color: Colors.black,
                    height: 800,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Top 10 mais ouvidos',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 250,
                          child: ListView.builder(
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Image.network(
                                    '${top10Tracks[index].album!.images!.first!.url}'),
                                title: Text(
                                  '${index + 1}. ${top10Tracks[index].name!}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  '${top10Tracks[index].album!.name}',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 20,
                          width: MediaQuery.sizeOf(context).width,
                          child: ElevatedButton(
                              onPressed: () {},
                              child: Center(
                                child: Text(
                                  'Mostrar tudo',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Discografia',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              color: showTopBar
                  ? Colors.transparent
                  : const Color(0xFFC61855).withOpacity(0),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: SafeArea(
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_left,
                            size: 38,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
