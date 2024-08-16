import 'package:flutter/material.dart';
import 'package:http/http.dart';

class DummyLancamento extends StatefulWidget {
  const DummyLancamento({super.key});

  @override
  State<DummyLancamento> createState() => _DummyLancamentoState();
}

class _DummyLancamentoState extends State<DummyLancamento> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 300,
      color: Colors.white,
    );
  }
}
