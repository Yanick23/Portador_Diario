import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portador_diario_client_app/pages/searchPage/searchPage.dart';
import 'package:portador_diario_client_app/pages/registerNumberPage/registerNumbrePage.dart';

class Onboardingpage extends StatefulWidget {
  const Onboardingpage({super.key});

  @override
  State<Onboardingpage> createState() => _OnboardingpageState();
}

class _OnboardingpageState extends State<Onboardingpage> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: OnboardingPagePresenter(
          onFinish: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterNumberPage(),
                ));
          },
          onSkip: () {},
          pages: [
            OnboardingPageModel(
              title: 'Encomendas rápidas e seguras',
              description:
                  'Faça suas compras e encomendas com poucos toques e receba no conforto de sua casa.',
              imageUrl: 'assets/Group 317.svg',
              bgColor: Color(0xFFFFFFFF),
            ),
            OnboardingPageModel(
              title: 'Rastreamento em tempo real',
              description:
                  'Acompanhe suas encomendas em tempo real com nossa tecnologia de rastreamento avançada.',
              imageUrl: 'assets/Group 317.svg',
              bgColor: Color(0xFFFFFFFF),
            ),
            OnboardingPageModel(
              title: 'Entregadores confiáveis',
              description:
                  'Trabalhamos com entregadores profissionais e de confiança para garantir que suas encomendas cheguem em segurança.',
              imageUrl: 'assets/Group 317.svg',
              bgColor: Color(0xFFFFFFFF),
            ),
          ]),
    );
  }
}

class OnboardingPagePresenter extends StatefulWidget {
  final List<OnboardingPageModel> pages;
  final VoidCallback? onSkip;
  final VoidCallback? onFinish;

  const OnboardingPagePresenter(
      {Key? key, required this.pages, this.onSkip, this.onFinish})
      : super(key: key);

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  int _currentPage = 0;

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: widget.pages[_currentPage].bgColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.pages.length,
                  onPageChanged: (idx) {
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final item = widget.pages[idx];
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.45,
                          item.imageUrl,
                          fit: BoxFit.cover,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  item.title,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 550),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(item.description,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color:
                                            Color.fromARGB(255, 46, 45, 45))),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.pages
                    .map((item) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: _currentPage == widget.pages.indexOf(item)
                              ? 30
                              : 8,
                          height: 8,
                          margin: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10.0)),
                        ))
                    .toList(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        visualDensity: VisualDensity.comfortable,
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      if (_currentPage == widget.pages.length - 1) {
                        widget.onFinish?.call();
                      } else {
                        _pageController.animateToPage(_currentPage + 1,
                            curve: Curves.easeInOutCubic,
                            duration: const Duration(milliseconds: 250));
                      }
                    },
                    child: Text(_currentPage == widget.pages.length - 1
                        ? "Registar-se"
                        : "A seguir"),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPageModel {
  final String title;
  final String description;
  final String imageUrl;
  final Color bgColor;
  final Color textColor;

  OnboardingPageModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.bgColor = Colors.blue,
    this.textColor = Colors.white,
  });
}
