import 'package:flutter/material.dart';
import 'package:futsal_booking_app/src/core/constants/string.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class NearbyFutsalMap extends StatefulWidget {
  const NearbyFutsalMap({super.key});

  @override
  State<NearbyFutsalMap> createState() => _NearbyFutsalMapState();
}

class _NearbyFutsalMapState extends State<NearbyFutsalMap> {
  late GoogleMapController _mapController;
  LatLng _currentLocation =
      const LatLng(28.2096, 83.9856); // Default to Pokhara
  final Set<Marker> _markers = {};
  Polyline? _routePolyline;
  final String _apiKey = AppString.googleApiKey; // Replace with your API Key
  List<FutsalField> _futsalFields = [];
  bool _isLocationFetched = false;

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
  }

  // Fetch user's current location
  Future<void> _fetchUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _isLocationFetched = true;
        });
        _fetchFutsalFields();
      } else {
        print("Location permission denied.");
      }
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  // Fetch futsal fields from Google Places API
  Future<void> _fetchFutsalFields() async {
    const String baseUrl =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';
    final String apiUrl =
        '$baseUrl?location=${_currentLocation.latitude},${_currentLocation.longitude}'
        '&radius=5000&type=sports_complex&keyword=futsal&key=$_apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['results'] != null && data['results'].isNotEmpty) {
        List<FutsalField> fields = [];
        for (var place in data['results']) {
          fields.add(
            FutsalField(
              name: place['name'],
              location: LatLng(
                place['geometry']['location']['lat'],
                place['geometry']['location']['lng'],
              ),
              address: place['vicinity'] ?? '',
            ),
          );
        }

        _calculateDistances(fields);
      } else {
        print("No futsal fields found in the response.");
      }
    } else {
      print("Failed to fetch futsal fields: ${response.statusCode}");
    }
  }

  // Calculate distances and mark nearest/farthest futsal fields
  void _calculateDistances(List<FutsalField> fields) {
    for (var field in fields) {
      field.distance = _calculateDistance(_currentLocation, field.location);
    }

    // Sort by distance
    fields.sort((a, b) => a.distance.compareTo(b.distance));

    setState(() {
      _futsalFields = fields;
      _markers.clear();

      // Add markers with nearest (green) and farthest (red) markers
      for (int i = 0; i < _futsalFields.length; i++) {
        _markers.add(
          Marker(
            markerId: MarkerId(_futsalFields[i].name),
            position: _futsalFields[i].location,
            infoWindow: InfoWindow(
              title: _futsalFields[i].name,
              snippet:
                  'Distance: ${_futsalFields[i].distance.toStringAsFixed(2)} km',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              i == 0
                  ? BitmapDescriptor.hueGreen // Nearest futsal
                  : i == _futsalFields.length - 1
                      ? BitmapDescriptor.hueRed // Farthest futsal
                      : BitmapDescriptor.hueOrange,
            ),
            onTap: () {
              _fetchRoute(_futsalFields[i].location); // Fetch route on tap
            },
          ),
        );
      }
    });
  }

  // Fetch route from current location to selected futsal field
  Future<void> _fetchRoute(LatLng destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation.latitude},${_currentLocation.longitude}&destination=${destination.latitude},${destination.longitude}&key=$_apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['routes'] != null && data['routes'].isNotEmpty) {
        final List<LatLng> routePoints =
            _decodePolyline(data['routes'][0]['overview_polyline']['points']);
        setState(() {
          _routePolyline = Polyline(
            polylineId: const PolylineId('route'),
            color: Colors.blue, // Blue color for route
            width: 5,
            points: routePoints,
          );
          _moveCameraToRoute(destination);
        });
      } else {
        print("No routes found in the response.");
      }
    } else {
      print("Failed to fetch route: ${response.statusCode}");
    }
  }

  // Move camera to fit the route
  void _moveCameraToRoute(LatLng destination) {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(min(_currentLocation.latitude, destination.latitude),
          min(_currentLocation.longitude, destination.longitude)),
      northeast: LatLng(max(_currentLocation.latitude, destination.latitude),
          max(_currentLocation.longitude, destination.longitude)),
    );

    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50), // 50 pixels padding
    );
  }

  // Decode polyline points
  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dLat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dLng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }

  // Calculate distance using Haversine formula
  double _calculateDistance(LatLng start, LatLng end) {
    const double radius = 6371; // Earth's radius in km
    double dLat = _degreesToRadians(end.latitude - start.latitude);
    double dLng = _degreesToRadians(end.longitude - start.longitude);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(start.latitude)) *
            cos(_degreesToRadians(end.latitude)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    return 2 * radius * atan2(sqrt(a), sqrt(1 - a));
  }

  double _degreesToRadians(double degrees) => degrees * pi / 180;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nearby Futsal Fields"),
        backgroundColor: Colors.green,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentLocation,
          zoom: 13,
        ),
        markers: _markers,
        polylines: _routePolyline != null ? {_routePolyline!} : {},
        myLocationEnabled: true,
        onMapCreated: (controller) => _mapController = controller,
      ),
    );
  }
}

class FutsalField {
  final String name;
  final LatLng location;
  final String address;
  double distance;

  FutsalField({
    required this.name,
    required this.location,
    required this.address,
    this.distance = 0.0,
  });
}