import 'dart:async';
import 'dart:convert';
import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as developer;

class NearbyHospitalsScreen extends StatefulWidget {
  const NearbyHospitalsScreen({super.key});

  @override
  State<NearbyHospitalsScreen> createState() => _NearbyHospitalsScreenState();
}

class _NearbyHospitalsScreenState extends State<NearbyHospitalsScreen> {
  Position? _currentPosition;
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};
  List<dynamic> _hospitals = [];
  bool _isLoading = true;

  // Replace with your Google Places API key
  final String _apiKey = 'xxx';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permissions are permanently denied.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    // Get current position
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      await _fetchNearbyHospitals();
      setState(() => _isLoading = false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting location: $e')),
      );
      setState(() => _isLoading = false);
    }
  }


  Future<void> _fetchNearbyHospitals() async {
    if (_currentPosition == null) {
      developer.log('Current position is null');
      return;
    }

    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
        '?location=${_currentPosition!.latitude},${_currentPosition!.longitude}'
        '&radius=5000'
        '&type=hospital'
        '&key=$_apiKey';

    developer.log('Fetching URL: $url');
    try {
      final response = await http.get(Uri.parse(url));
      developer.log('Response status: ${response.statusCode}, Body: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] != 'OK') {
          developer.log('API Error: ${data['status']} - ${data['error_message'] ?? 'No error message'}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi API: ${data['status']}')),
          );
          return;
        }
        setState(() {
          _hospitals = data['results'];
          _markers.clear();
          for (var hospital in _hospitals) {
            final position = LatLng(
              hospital['geometry']['location']['lat'],
              hospital['geometry']['location']['lng'],
            );
            _markers.add(
              Marker(
                markerId: MarkerId(hospital['place_id']),
                position: position,
                infoWindow: InfoWindow(
                  title: hospital['name'],
                  snippet: hospital['vicinity'],
                ),
              ),
            );
          }
        });
        final controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
              ),
              zoom: 14,
            ),
          ),
        );
      } else {
        developer.log('Failed to fetch hospitals: ${response.statusCode} - ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể tải danh sách bệnh viện.')),
        );
      }
    } catch (e) {
      developer.log('Error fetching hospitals: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải bệnh viện: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final AppLocalizations localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('nearby_hospital'),
          style: GoogleFonts.poppins(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryRed,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentPosition == null
          ? const Center(child: Text('Unable to get location.'))
          : Column(
        children: [
          // Map Section
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentPosition!.latitude,
                  _currentPosition!.longitude,
                ),
                zoom: 14,
              ),
              markers: _markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          // Hospital List Section
          Expanded(
            child: ListView.builder(
              itemCount: _hospitals.length,
              itemBuilder: (context, index) {
                final hospital = _hospitals[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      hospital['name'],
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      hospital['vicinity'],
                      style: GoogleFonts.poppins(),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.directions),
                      onPressed: () {
                        // Open Google Maps with directions
                        final lat = hospital['geometry']['location']['lat'];
                        final lng = hospital['geometry']['location']['lng'];
                        final url = 'https://www.google.com/maps/dir/?api=1'
                            '&destination=$lat,$lng';
                        launchUrl(Uri.parse(url));
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}