import 'package:flutter/material.dart';

class DummyCard extends StatefulWidget {
  const DummyCard({super.key});

  @override
  State<DummyCard> createState() => _DummyCardState();
}

class _DummyCardState extends State<DummyCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
      ),
    );
  }
}
