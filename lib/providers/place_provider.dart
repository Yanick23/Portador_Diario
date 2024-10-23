import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:portador_diario_client_app/model/place.dart';

class PlaceProvider with ChangeNotifier {
  List<Color> _polylinesColors =
      []; // Lista para armazenar as cores das polilinhas

  Place? _localDeRecolha;
  List<Place> _locaisDeEntrega = [];
  List<LatLng> _polylines = [];
  final String apiKey = 'AIzaSyBSquwmDbyci_M5PuH7UoLRd8A1F9AZqe4';
  Place? get localDeRecolha => _localDeRecolha;
  List<Place> get locaisDeEntrega => _locaisDeEntrega;
  List<LatLng> get polylines => _polylines;
  String? _tempoDeViagem;
  String? get tempoDeViagem => _tempoDeViagem;
  void setLocalDeRecolha(Place localRecolha) {
    _localDeRecolha = localRecolha;
    notifyListeners();
  }

  void adicionarLocalDeEntrega(Place localEntrega) {
    _locaisDeEntrega.add(localEntrega);
    notifyListeners();
  }

  void removerLocalDeEntrega(String placeId) {
    _locaisDeEntrega.removeWhere((local) => local.placeId == placeId);
    notifyListeners();
  }

  void limparLocaisDeEntrega() {
    _locaisDeEntrega.clear();
    notifyListeners();
  }

  Future<void> obterRota(LatLng origem, LatLng destino) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origem.latitude},${origem.longitude}&destination=${destino.latitude},${destino.longitude}&departure_time=now&traffic_model=best_guess&key=$apiKey';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['routes'] != null && data['routes'].isNotEmpty) {
        var route = data['routes'][0];
        var leg = route['legs'][0]; // Informações sobre a rota

        // Decodificar a polilinha
        var polylinePoints = PolylinePoints()
            .decodePolyline(route['overview_polyline']['points']);
        _polylines = polylinePoints
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        // Obter informações de tráfego
        var duration = leg['duration']['value']; // Tempo de viagem sem tráfego
        var durationInTraffic =
            leg['duration_in_traffic']['value']; // Tempo de viagem com tráfego

        // Calcular a diferença para definir a cor
        double trafficFactor = durationInTraffic / duration;

        // Definir cor da polilinha com base no tráfego
        Color polylineColor;
        if (trafficFactor < 1.5) {
          polylineColor = Colors.green; // Boa condição de tráfego
        } else if (trafficFactor < 2.0) {
          polylineColor = Colors.yellow; // Tráfego moderado
        } else {
          polylineColor = Colors.red; // Tráfego pesado
        }

        // Armazenar a cor da polilinha
        _polylinesColors.clear(); // Limpar cores anteriores
        _polylinesColors.add(polylineColor); // Adicionar a nova cor

        // Obter o tempo de viagem considerando o tráfego
        _tempoDeViagem =
            leg['duration_in_traffic']['text']; // Exemplo: "20 mins"

        notifyListeners();
      } else {
        throw Exception('Nenhuma rota encontrada.');
      }
    } else {
      throw Exception('Erro ao chamar Directions API: ${response.statusCode}');
    }
  }

  void cancelarEntrega() {
    _localDeRecolha = null; // Limpa o local de recolha
    _locaisDeEntrega.clear(); // Limpa os locais de entrega
    limparRota(); // Limpa a rota (polylines e tempo de viagem)
    notifyListeners();
  }

  void limparRota() {
    _polylines.clear();
    _tempoDeViagem = null; // Limpa o tempo de viagem
    notifyListeners();
  }
}
