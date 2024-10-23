import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:portador_diario_client_app/controllers/mapcontrollerPD.dart';
import 'package:portador_diario_client_app/model/place.dart';
import 'package:portador_diario_client_app/providers/place_provider.dart';
import 'package:portador_diario_client_app/widgets/OrderFormWidget.dart';
import 'package:portador_diario_client_app/widgets/localizacaoInputWidget.dart';
import 'package:portador_diario_client_app/widgets/locationPickerSheet.dart';
import 'package:provider/provider.dart';

class SendOrderPage extends StatefulWidget {
  const SendOrderPage({super.key});

  @override
  State<SendOrderPage> createState() => _SendOrderPageState();
}

class _SendOrderPageState extends State<SendOrderPage> {
  late Future<List<String>> search;
  bool drag1 = true;
  bool drag2 = false;
  List<String> enderecos = [];
  late TextEditingController senderController = TextEditingController();

  TextEditingController recipientController = TextEditingController();

  final List<bool> _isExpanded = [];
  final String apiKey = 'AIzaSyBSquwmDbyci_M5PuH7UoLRd8A1F9AZqe4';
  late CameraPosition _initialCameraPosition;
  late GoogleMapController mapController;
  Place? _currentLocation =
      Place(placeName: '', placeId: '', latitude: 1000000000, longitude: 1);
  final String _EnderecoEntrega = "";
  final Set<Marker> _markers = {};
  Position? _currentPosition;
  final Completer<GoogleMapController> _controller = Completer();
  final List<Polyline> _polylines = [];
  BitmapDescriptor costumIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor costumIcon2 = BitmapDescriptor.defaultMarker;

  void costum() {
    BitmapDescriptor.asset(
            ImageConfiguration(), 'assets/icons8-location-64.png')
        .then(
      (value) {
        costumIcon = value;
      },
    );
  }

  void costum2() {
    BitmapDescriptor.asset(
            ImageConfiguration(), 'assets/icons8-destination-64.png')
        .then(
      (value) {
        costumIcon2 = value;
      },
    );
  }

  final String mapStyle = '''
    [
     
    ]
  ''';
  List<LatLng> pontosEntrega = [
    const LatLng(37.7849, -122.4094),
    const LatLng(37.7649, -122.4294),
    const LatLng(37.7549, -122.4394),
  ];
  GoogleMapController? _mapController;
  LatLng _centerPosition = LatLng(-25.9653, 32.5892);
  LatLng _pinPosition = LatLng(-25.9653, 32.5892);

  bool _isDragging = false;
  double _pinHeight = 0.0;
  double _pinOpacity = 1.0;

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _centerPosition = position.target;
    });
  }

  void _onCameraIdle() {
    if (_isDragging) {
      setState(() {
        _pinPosition = _centerPosition;
        _isDragging = false;
        _pinHeight = 0.0; // Alfinete abaixa
        _pinOpacity = 1.0; // Torna totalmente visível
      });
    }
  }

  @override
  initState() {
    super.initState();
    costum();
    costum2();
    _initialCameraPosition = const CameraPosition(
      target: LatLng(0, 0),
      zoom: 14.0,
    );

    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'O serviço de localização está desativado.';
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'A permissão de localização foi negada.';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'A permissão de localização foi negada permanentemente.';
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _currentPosition = position;
        _initialCameraPosition = CameraPosition(
          target:
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 14.0,
        );
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(_initialCameraPosition),
      );
      _currentLocation = await MapcontrollerPD().getAddressFromCoordinates(
          _currentPosition!.latitude, _currentPosition!.longitude);
      Provider.of<PlaceProvider>(context, listen: false)
          .setLocalDeRecolha(_currentLocation!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _ajustarCamera(LatLng localRecolha, LatLng localEntrega) async {
    final GoogleMapController controller = await _controller.future;

    double lat = (localRecolha.latitude + localEntrega.latitude) / 2;
    double lng = (localRecolha.longitude + localEntrega.longitude) / 2;

    CameraPosition cameraPosition = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 12.0,
    );

    setState(() {
      _initialCameraPosition = cameraPosition;
    });

    controller.moveCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Set<Marker> _buildMarkers(PlaceProvider placeProvider) {
    Set<Marker> markers = {};

    if (placeProvider.localDeRecolha != null &&
        placeProvider.locaisDeEntrega.isNotEmpty) {
      markers.add(
        Marker(
          markerId: MarkerId('recolha'),
          position: LatLng(
            placeProvider.localDeRecolha!.latitude,
            placeProvider.localDeRecolha!.longitude,
          ),
          infoWindow: InfoWindow(title: 'Local de Recolha'),
        ),
      );
    }

    for (Place localEntrega in placeProvider.locaisDeEntrega) {
      markers.add(
        Marker(
          markerId: MarkerId(localEntrega.placeId),
          position: LatLng(
            localEntrega.latitude,
            localEntrega.longitude,
          ),
          infoWindow: InfoWindow(title: 'Local de Entrega'),
        ),
      );
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    bool cameraNeedsAdjustment = true;
    return Scaffold(
        body: _currentPosition == null ||
                _currentLocation == null ||
                _initialCameraPosition == null
            ? Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                    color: Theme.of(context).primaryColor, size: 30))
            : SafeArea(
                child: Stack(
                  children: [
                    Consumer<PlaceProvider>(
                      builder: (context, placeProvider, child) {
                        if (placeProvider.localDeRecolha != null &&
                            placeProvider.locaisDeEntrega.isNotEmpty &&
                            cameraNeedsAdjustment) {
                          cameraNeedsAdjustment = false;

                          placeProvider
                              .obterRota(
                            LatLng(
                              placeProvider.localDeRecolha!.latitude,
                              placeProvider.localDeRecolha!.longitude,
                            ),
                            LatLng(
                              placeProvider.locaisDeEntrega.first.latitude,
                              placeProvider.locaisDeEntrega.first.longitude,
                            ),
                          )
                              .then((_) async {
                            final GoogleMapController controller =
                                await _controller.future;

                            if (placeProvider.polylines.isNotEmpty) {
                              var polyline = placeProvider.polylines;

                              double south = polyline
                                  .map((point) => point.latitude)
                                  .reduce((a, b) => a < b ? a : b);
                              double north = polyline
                                  .map((point) => point.latitude)
                                  .reduce((a, b) => a > b ? a : b);
                              double east = polyline
                                  .map((point) => point.longitude)
                                  .reduce((a, b) => a > b ? a : b);
                              double west = polyline
                                  .map((point) => point.longitude)
                                  .reduce((a, b) => a < b ? a : b);

                              LatLngBounds bounds = LatLngBounds(
                                southwest: LatLng(south, west),
                                northeast: LatLng(north, east),
                              );

                              await controller.animateCamera(
                                  CameraUpdate.newLatLngBounds(bounds, 100));
                            }
                          });
                        }

                        return GoogleMap(
                          polylines: {
                            if (placeProvider.polylines.isNotEmpty)
                              Polyline(
                                polylineId: PolylineId('rota_recolha_entrega'),
                                color: Theme.of(context).primaryColor,
                                width: 5,
                                points: placeProvider.polylines,
                              ),
                          },
                          onCameraMoveStarted: () {
                            cameraNeedsAdjustment = false;
                          },
                          onCameraIdle: () {
                            cameraNeedsAdjustment = true;
                          },
                          style: mapStyle,
                          initialCameraPosition: _initialCameraPosition,
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          markers: _buildMarkers(placeProvider),
                          onMapCreated: (GoogleMapController controller) async {
                            _controller.complete(controller);
                          },
                        );
                      },
                    ),
                    if (drag1)
                      LocationPickerSheet(
                        enderecoDestino: _currentLocation!.placeName,
                        onRemetenteEDestinatario: (p0) {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return const LocalizacaoInput();
                            },
                          );
                        },
                        destinoTitle: _EnderecoEntrega == ""
                            ? _EnderecoEntrega
                            : "Endereco de Recolha",
                        enderecoRecolha: _currentLocation!.placeName,
                      ),
                  ],
                ),
              ),
        bottomSheet: _currentPosition == null ||
                _currentLocation == null ||
                _initialCameraPosition == null
            ? SizedBox()
            : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 122, 122, 122)
                          .withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, -3),
                    ),
                    BoxShadow(
                      color: const Color.fromARGB(255, 204, 204, 204)
                          .withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, -3),
                    ),
                    BoxShadow(
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                height: 75,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: SizedBox(
                    height: 80,
                    width: 350,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return const OrderFormWidget();
                          },
                        );
                      },
                      child: const Text(
                        'Adicionar  os dados ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ));
  }
}
