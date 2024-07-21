import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: Color.fromRGBO(148, 148, 148, 1)),
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: EdgeInsets.all(20),
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: const TextField(
                  decoration: InputDecoration(
                      hintMaxLines: null,
                      hintText: 'Pesquisa',
                      hintStyle: TextStyle(fontSize: 15),
                      icon: Icon(
                        Icons.search,
                        size: 30,
                      ),
                      border: InputBorder.none),
                ))
          ],
        ),
      ),
    );
  }
}
