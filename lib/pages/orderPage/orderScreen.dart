import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:portador_diario_client_app/pages/orderPage/sendOrderPage.dart';
import 'package:portador_diario_client_app/pages/orderPage/orderDetailsPage.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _selectedIndex = 0;
  List<String> tabs = ["Pendentes", "Todas", "Finalizadas"];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> readQRcode() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
        "#FFFFFF", "Cancelar", true, ScanMode.BARCODE);
    if (code != '-1') {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: 130,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(
                      bottom: 60, top: 8, left: 10, right: 10),
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PackageDetailsScreen(),
                            ));
                      },
                      child: _buildOrderCard(
                        status: "Em progresso", // Estado da entrega
                        title: "Chegando hoje!", // Título da entrega
                        deliveryId: "NEJ20089231", // ID de exemplo
                        location: "Maputo", // Local de origem
                        price: "1400 MZN", // Preço da entrega
                        date: "20 de setembro de 2023", // Data estimada
                        statusColor: Colors.green, // Cor do estado
                        statusIconPath: Icon(
                          Icons.autorenew,
                          color: Colors.green,
                        ), // Ícone de estado
                        packageImagePath:
                            "assets/icons/package_image.png", // Caminho da imagem da encomenda
                      ),
                    ),
                    _buildOrderCard(
                      status: "Concluído", // Estado atual
                      title: "Entrega concluída!",
                      deliveryId: "ABC123456789", // ID de exemplo
                      location: "Beira", // Local de origem
                      price: "1200 MZN", // Preço da entrega
                      date: "18 de setembro de 2023", // Data de conclusão
                      statusColor: Colors.blue, // Cor do estado
                      statusIconPath: Icon(
                        Icons.check_circle,
                        color: Colors.blue,
                      ), // Ícone de estado
                      packageImagePath:
                          "assets/icons/package_image.png", // Caminho da imagem da encomenda
                    ),
                    _buildOrderCard(
                      status: "Pendente", // Estado atual
                      title: "Aguardando confirmação!",
                      deliveryId: "XYZ987654321", // ID de exemplo
                      location: "Nampula", // Local de origem
                      price: "1500 MZN", // Preço da entrega
                      date: "Ainda não definido", // Data estimada
                      statusColor: Colors.orange, // Cor do estado
                      statusIconPath: Icon(
                        Icons.hourglass_empty,
                        color: Colors.orange,
                      ), // Ícone de estado
                      packageImagePath:
                          "assets/icons/package_image.png", // Caminho da imagem da encomenda
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            height: 120,
            decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Encomendas",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(tabs.length, (index) {
                    return ElevatedButton(
                      onPressed: () {
                        _onItemTapped(index);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedIndex == index
                            ? Colors.yellow
                            : Colors.grey.shade200,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          color: _selectedIndex == index
                              ? Colors.black
                              : Colors.grey.shade600,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(0, 4),
                blurRadius: 6.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: IconButton(
            autofocus: true,
            iconSize: 25,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SendOrderPage(),
                ),
              );
            },
            icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String status,
    required String title,
    required String deliveryId,
    required String location,
    required String price,
    required String date,
    required Color statusColor,
    required Widget statusIconPath,
    required String packageImagePath,
  }) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Chip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  side: BorderSide(color: statusColor),
                  backgroundColor: Colors.white,
                  avatar: statusIconPath, // Ícone de status
                  label: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.visibility),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PackageDetailsScreen(),
                        ));
                  },
                  tooltip: 'Ver detalhes',
                ),
              ],
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Sua entrega, #$deliveryId\nde $location, está chegando hoje!',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                // Imagem da caixa
                Row(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SvgPicture.asset(
                        'assets/Group (1).svg',
                        height: 50,
                        width: 50,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ],
            ),

            SizedBox(height: 10),

            // Preço e Data
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.purple,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
