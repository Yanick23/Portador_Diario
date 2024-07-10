import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spoti_stream_music/pages/pageViewFavoriteMusic.dart';

class Favoritoscreen extends StatefulWidget {
  const Favoritoscreen({super.key});

  @override
  State<Favoritoscreen> createState() => _FavoritoscreenState();
}

class _FavoritoscreenState extends State<Favoritoscreen> {
  int _selectedIndex = 0;

  late Color color = Color(0xFF00EEFF);
  late Color color2 = Colors.transparent;

  static final List<Widget> _widgetOptions = [
    PageViewFavoriteMusic(),
    Center(child: Text("6"))
  ];

  void _onItemTapped_1(int index) {
    setState(() {
      _selectedIndex = index;

      print("kk");
      color = Color(0xFF00EEFF);
      color2 = Colors.transparent;
    });
  }

  void _onItemTapped_2(int index) {
    setState(() {
      _selectedIndex = index;
      color2 = Color(0xFF00EEFF);
      color = Colors.transparent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 278,
                color: const Color.fromARGB(255, 37, 36, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8, right: 8, top: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Spoti Stream nusic",
                            style: TextStyle(color: Colors.grey),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  color: Colors.grey,
                                  Icons.notifications_none_outlined,
                                  size: 30,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  color: Colors.grey,
                                  Icons.settings,
                                  size: 30,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 20, left: 8, right: 8),
                      child: const Text("Ouvido recentimente",
                          style: TextStyle(
                              color: Color.fromARGB(255, 221, 221, 221),
                              fontSize: 18)),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            alignment: Alignment.bottomLeft,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey),
                            child: IconButton(
                              icon: const Icon(
                                Icons.play_circle_fill,
                                size: 40,
                              ),
                              onPressed: () => {},
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey),
                            child: IconButton(
                              icon: const Icon(
                                Icons.play_circle_fill,
                                size: 40,
                              ),
                              onPressed: () => {},
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey),
                            child: IconButton(
                              icon: const Icon(
                                Icons.play_circle_fill,
                                size: 40,
                              ),
                              onPressed: () => {},
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey),
                            child: IconButton(
                              icon: const Icon(
                                Icons.play_circle_fill,
                                size: 40,
                              ),
                              onPressed: () => {},
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _onItemTapped_1(0);
                          },
                          child: Container(
                            width: 185,
                            child: Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.only(top: 12),
                                    child: Text(
                                      "Musica",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                Container(
                                    alignment: Alignment(0, 6),
                                    child: Container(height: 2, color: color))
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _onItemTapped_2(1);
                          },
                          child: Container(
                            width: 185,
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 12),
                                  child: Center(
                                    child: Text("Podcasts",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment(0, 6),
                                    child: Container(height: 2, color: color2))
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                child: _widgetOptions[_selectedIndex],
              )
            ],
          ),
        ));
  }
}
