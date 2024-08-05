import 'package:flutter/material.dart';

class DummyListViewCell extends StatefulWidget {
  const DummyListViewCell({super.key});

  @override
  State<DummyListViewCell> createState() => _DummyListViewCellState();
}

class _DummyListViewCellState extends State<DummyListViewCell> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              color: Colors.white,
            ),
            Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 8,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                Container(
                  width: double.infinity,
                  height: 8,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                Container(
                  width: 40,
                  height: 8,
                  color: Colors.white,
                ),
              ],
            ))
          ],
        ));
  }
}
