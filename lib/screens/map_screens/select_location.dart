import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../models/address.dart';

class MyMap extends StatefulWidget {
  final bool showLocation;
  const MyMap({super.key, required this.showLocation});

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    if(widget.showLocation) {
      List<Address> addresses = [
        Address("Address 1", const LatLng(37.7749, -122.4194)),
        Address("Address 2", const LatLng(34.0522, -118.2437)),
      ];
      for (var address in addresses) {
        _markers.add(
          Marker(
            markerId: MarkerId(address.name),
            position: address.location,
              draggable: false,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
            onTap: () {
              _showDetailsDialog(context, address);
            },
          ),
        );
      }
    } else {
      _getCurrentLocation();
    }
  }

  final Location _location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _currentLocation;

  Future<void> _checkLocationPermission() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _currentLocation = await _location.getLocation();
    setState(() {
      _selectedLocation = LatLng(_currentLocation.latitude!, _currentLocation.longitude!);
    });
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(_selectedLocation),
    );
  }

  GoogleMapController? _mapController;
  LatLng _selectedLocation = const LatLng(34.0522, -118.2437);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GoogleMap(
            myLocationEnabled: true,
            initialCameraPosition: const CameraPosition(
              target: LatLng(37.7749, -122.4194),
              zoom: 5.0,
            ),
            onMapCreated: (controller) async {
              setState(() {
                _mapController = controller;
              });
            },
            onTap: (LatLng latLng) {
              setState(() {
                _selectedLocation = latLng;
              });
            },
            markers: widget.showLocation ? _markers : {
              Marker(
                  markerId: const MarkerId('drop'),
                  position: _selectedLocation,
                  draggable: true,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed)),
            },
          ),
        ),
        const SizedBox(height: 16.0),
        Visibility(
          visible: !widget.showLocation,
          child: ElevatedButton(
            onPressed: () {
              _showLocationDetailsDialog(context, _selectedLocation);
            },
            child: const Text('Select this Location'),
          ),
        ),
      ],
    );
  }

  void _showLocationDetailsDialog(BuildContext context, LatLng location) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selected Location'),
          content: Text('Latitude: ${location.latitude}\nLongitude: ${location.longitude}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showDetailsDialog(BuildContext context, Address address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Address Details'),
          content: Text(address.name),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
