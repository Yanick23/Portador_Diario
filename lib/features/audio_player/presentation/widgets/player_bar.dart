import 'package:flutter/material.dart';
import 'dart:ui';

class PlayerBar extends StatelessWidget {
  const PlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            border: const Border(top: BorderSide(color: Colors.white10, width: 0.5)),
          ),
          child: Row(
            children: [
              // Track Info
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white10,
                        boxShadow: const [
                          BoxShadow(color: Colors.black45, blurRadius: 10, spreadRadius: 0)
                        ],
                      ),
                      child: const Icon(Icons.music_note, color: Colors.white24),
                    ),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Song Title',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Artist Name',
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.white54, size: 20),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Controls
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(icon: const Icon(Icons.shuffle, color: Colors.white54, size: 20), onPressed: () {}),
                        IconButton(icon: const Icon(Icons.skip_previous, color: Colors.white, size: 28), onPressed: () {}),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow, color: Colors.black, size: 28),
                        ),
                        IconButton(icon: const Icon(Icons.skip_next, color: Colors.white, size: 28), onPressed: () {}),
                        IconButton(icon: const Icon(Icons.repeat, color: Colors.white54, size: 20), onPressed: () {}),
                      ],
                    ),
                    const SizedBox(height: 4),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
                        activeTrackColor: Colors.blue,
                        inactiveTrackColor: Colors.white10,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 10,
                        child: Row(
                          children: [
                            const Text('0:00', style: TextStyle(color: Colors.white54, fontSize: 10)),
                            const Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: LinearProgressIndicator(
                                  value: 0.3,
                                  backgroundColor: Colors.white10,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                ),
                              ),
                            ),
                            const Text('3:45', style: TextStyle(color: Colors.white54, fontSize: 10)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Side Controls
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(icon: const Icon(Icons.playlist_play, color: Colors.white54, size: 20), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.devices, color: Colors.white54, size: 20), onPressed: () {}),
                    const Icon(Icons.volume_up, color: Colors.white54, size: 20),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 100,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                          activeTrackColor: Colors.white,
                          inactiveTrackColor: Colors.white10,
                          thumbColor: Colors.white,
                        ),
                        child: Slider(value: 0.5, onChanged: (v) {}),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
