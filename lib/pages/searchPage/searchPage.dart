import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portador_diario_client_app/widgets/shippingTimeline.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  int _selectedIndex = 0;

  ScrollController controller = ScrollController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> readQRcode() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
        "#FFFFFF", "Cancelar", true, ScanMode.QR);
    if (code != '-1') {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        // Removendo o SingleChildScrollView interno
        child: Column(
          children: [
            Container(
              height: 240,
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        trailing: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(0),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.1),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          "Sua localização",
                          style: TextStyle(
                            color: const Color.fromARGB(255, 211, 206, 206),
                          ),
                        ),
                        subtitle: Text(
                          "Maputo, Moçambique",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      const Text(
                        'Vamos rastrear a sua encomenda!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: 'ADL020030907PD',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              readQRcode();
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.yellow,
                              child: Icon(
                                Icons.qr_code_scanner_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMenuButton(
                          'Envios',
                          SvgPicture.asset("assets/kk.svg",
                              width: 28, height: 23)),
                      _buildMenuButton('Recebimentos',
                          SvgPicture.asset("assets/Group (1).svg")),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildSectionTitle('Histórico de rastreio', 'Ver tudo'),
                  SizedBox(height: 10),
                  _buildTrackingItem('Encomenda 1', 'M9949065'),
                  const SizedBox(height: 10),
                  _buildTrackingItem('Encomenda 2', 'M9949089'),
                  SizedBox(height: 10),
                  _buildSectionTitle('Envio atual', ''),
                  SizedBox(height: 10),
                  _buildCurrentTrackingItem('Encomenda 3', 'M9979010'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função auxiliar para criar um botão de menu
  Widget _buildMenuButton(String label, Widget icon) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          radius: 25,
          child: icon,
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(color: Colors.grey)),
      ],
    );
  }

  // Função auxiliar para criar título de seção
  Widget _buildSectionTitle(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        if (actionText.isNotEmpty)
          Text(
            actionText,
            style: const TextStyle(color: Colors.blue),
          ),
      ],
    );
  }

  Widget _buildTrackingItem(String title, String id) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.purple.withOpacity(0.2),
                radius: 22,
                child: SvgPicture.asset("assets/Group (1).svg"),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  Text('ID: $id', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildCurrentTrackingItem(String title, String id) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.blue),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.purple.withOpacity(0.2),
                radius: 22,
                child: SvgPicture.asset("assets/Group (1).svg"),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  Text('ID: $id', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        ],
      ),
    );
  }
}
