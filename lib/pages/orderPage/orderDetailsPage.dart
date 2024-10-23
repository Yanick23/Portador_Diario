import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PackageDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String senderPhoneNumber = '+258 123 456 789'; // Número do remetente
    final String recipientPhoneNumber =
        '+258 987 654 321'; // Número do destinatário

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detalhes da Encomenda',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8.0,
                      spreadRadius: 2.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 200,
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(-25.9687, 32.5833),
                            initialZoom: 13.2,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.app',
                            ),
                            RichAttributionWidget(
                              attributions: [
                                TextSourceAttribution(
                                  'Contribuidores do OpenStreetMap',
                                  onTap: () => launchUrl(Uri.parse(
                                      'https://openstreetmap.org/copyright')),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Botão Rastreamento ao Vivo
                    ElevatedButton(
                      onPressed: () {
                        // Adicionar ação de rastreamento ao vivo aqui
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Rastreamento ao Vivo',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Nome do Pedido',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'iPhone 14 Plus',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '#767576',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Telefone',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                            Text(
                              '$recipientPhoneNumber',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.call, color: theme.primaryColor),
                              onPressed: () {
                                launchUrl(
                                    Uri.parse('tel:$recipientPhoneNumber'));
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.message,
                                  color: theme.primaryColor),
                              onPressed: () {
                                launchUrl(
                                    Uri.parse('sms:$recipientPhoneNumber'));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8.0,
                        spreadRadius: 2.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Status da Entrega',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('Atualizar',
                                style: TextStyle(color: theme.primaryColor)),
                          ),
                        ],
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading:
                            Icon(Icons.check_circle, color: theme.primaryColor),
                        title: Text(
                          'Em posse do agente',
                          style: TextStyle(fontSize: 13),
                        ),
                        trailing: const Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '12:30 PM',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              '12 Dez 2024',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: Icon(Icons.circle, color: Colors.grey),
                        title: Text(
                          'A caminho com o entregador',
                          style: TextStyle(fontSize: 13),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '10:30 PM',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              '15 Dez 2024',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: Icon(Icons.circle, color: Colors.grey),
                        title: Text(
                          'Recebido pelo destinatário',
                          style: TextStyle(fontSize: 13),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '10:30 PM',
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              '15 Dez 2024',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: theme.primaryColor)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      "Nova Encomenda",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor),
                    ),
                    trailing: Icon(
                      Icons.add,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  launchUrl(Uri parse) {}
}
