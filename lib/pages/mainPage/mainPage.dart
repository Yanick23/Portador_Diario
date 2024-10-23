import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:portador_diario_client_app/pages/searchPage/searchPage.dart';
import 'package:portador_diario_client_app/pages/onboardPage/onboardingPage.dart';
import 'package:portador_diario_client_app/pages/registerClientPage/registerClientPage.dart';
import 'package:portador_diario_client_app/pages/orderPage/orderScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    OrderScreen(),
    SearchPage(),
    OrderScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, -2),
              blurRadius: 4.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: NavigationBar(
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: Icon(
                FontAwesomeIcons.box,
                color: _selectedIndex == 0 ? Colors.white : theme.primaryColor,
              ),
              label: 'Encomendas',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.search,
                color: _selectedIndex == 1 ? Colors.white : theme.primaryColor,
              ),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.support_agent_outlined,
                color: _selectedIndex == 2 ? Colors.white : theme.primaryColor,
              ),
              label: 'Agente',
            ),
          ],
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.transparent,
          indicatorColor: theme.primaryColor,
        ),
      ),
    );
  }
}
