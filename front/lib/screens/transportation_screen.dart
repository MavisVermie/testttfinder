import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/transportation_service.dart';

class TransportationScreen extends StatefulWidget {
  const TransportationScreen({super.key});

  @override
  State<TransportationScreen> createState() => _TransportationScreenState();
}

class _TransportationScreenState extends State<TransportationScreen> {
  // Controllers
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  
  // Google Maps
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng? _currentLocation;
  
  // UI State
  bool _showSearchResults = false;
  bool _showDirections = false;
  bool _isLoadingLocation = false;
  String _selectedTransportMode = 'driving';
  MapType _currentMapType = MapType.normal;
  
  // Data
  List<Map<String, dynamic>> _searchResults = [];
  Map<String, dynamic>? _selectedRoute;
  List<Map<String, dynamic>> _nearbyStations = [];
  
  // Google Maps API Key - REPLACE WITH YOUR ACTUAL KEY
  static const String _googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY_HERE';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Request location permission
      final permission = await Permission.location.request();
      if (permission != PermissionStatus.granted) {
        setState(() {
          _isLoadingLocation = false;
        });
        _showLocationPermissionDialog();
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });

      // Add current location marker
      _addMarker(
        _currentLocation!,
        'Current Location',
        BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );

      // Get nearby transportation data
      await _getNearbyTransportation();
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      _showErrorDialog('Location Error', 'Failed to get your location: $e');
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text('This app needs location permission to show your position on the map.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _getNearbyTransportation() async {
    if (_currentLocation == null) return;

    try {
      final result = await TransportationService.getNearbyTransportation(
        latitude: _currentLocation!.latitude,
        longitude: _currentLocation!.longitude,
        radius: 1000,
        transportType: 'all',
      );

      if (result['success'] == true) {
        setState(() {
          _nearbyStations = List<Map<String, dynamic>>.from(
            result['data']['nearbyOptions'] ?? [],
          );
        });
        _addTransportationMarkers();
      }
    } catch (e) {
      print('Error getting nearby transportation: $e');
    }
  }

  void _addTransportationMarkers() {
    for (int i = 0; i < _nearbyStations.length; i++) {
      final station = _nearbyStations[i];
      if (station['coordinates'] != null) {
        final coords = station['coordinates'];
        final position = LatLng(coords['lat'], coords['lng']);
        
        _addMarker(
          position,
          station['name'] ?? 'Transportation Station',
          station['type'] == 'bus' 
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
              : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
      }
    }
  }

  void _addMarker(LatLng position, String title, BitmapDescriptor icon) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(title),
          position: position,
          icon: icon,
          infoWindow: InfoWindow(title: title),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // Google Maps
          _buildGoogleMap(),
          
          // Top App Bar
          _buildTopAppBar(),
          
          // Search Bar
          _buildSearchBar(),
          
          // Search Results
          if (_showSearchResults) _buildSearchResults(),
          
          // Directions Panel
          if (_showDirections) _buildDirectionsPanel(),
          
          // Transport Mode Selector
          if (_showDirections) _buildTransportModeSelector(),
          
          // Map Controls
          _buildMapControls(),
        ],
      ),
    );
  }

  Widget _buildGoogleMap() {
    if (_isLoadingLocation) {
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 16),
              Text(
                'Getting your location...',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return GoogleMap(
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      initialCameraPosition: CameraPosition(
        target: _currentLocation ?? const LatLng(31.9539, 35.9106), // Amman, Jordan
        zoom: 15.0,
      ),
      markers: _markers,
      polylines: _polylines,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapType: _currentMapType,
      zoomControlsEnabled: false,
      compassEnabled: true,
      onTap: (LatLng position) {
        setState(() {
          _showSearchResults = false;
        });
      },
    );
  }

  Widget _buildTopAppBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Back button
            _buildFloatingButton(
              icon: Icons.arrow_back,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(width: 12),
            // Search field
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search for places',
                    hintStyle: GoogleFonts.roboto(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Menu button
            _buildFloatingButton(
              icon: Icons.menu,
              onTap: () => _showMenu(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.black87,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 100,
      left: 16,
      right: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildLocationField(
              controller: _fromController,
              icon: Icons.circle,
              iconColor: Colors.blue,
              hintText: 'Choose starting point',
            ),
            Container(
              height: 1,
              color: Colors.grey[200],
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            _buildLocationField(
              controller: _toController,
              icon: Icons.location_on,
              iconColor: Colors.red,
              hintText: 'Choose destination',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required IconData icon,
    required Color iconColor,
    required String hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.roboto(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onTap: () {
                setState(() {
                  _showSearchResults = true;
                });
              },
            ),
          ),
          if (controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                controller.clear();
                setState(() {});
              },
              child: Icon(
                Icons.clear,
                color: Colors.grey[600],
                size: 20,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Positioned(
      top: 220,
      left: 16,
      right: 16,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 300),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _searchResults.isEmpty
            ? Container(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'No results found',
                    style: GoogleFonts.roboto(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final result = _searchResults[index];
                  return _buildSearchResultItem(result);
                },
              ),
      ),
    );
  }

  Widget _buildSearchResultItem(Map<String, dynamic> result) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.location_on,
          color: Colors.blue[600],
          size: 20,
        ),
      ),
      title: Text(
        result['name'] ?? 'Unknown place',
        style: GoogleFonts.roboto(
          fontSize: 16,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        result['formatted_address'] ?? '',
        style: GoogleFonts.roboto(
          fontSize: 14,
          color: Colors.grey[600],
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => _selectSearchResult(result),
    );
  }

  Widget _buildDirectionsPanel() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Directions content
            Expanded(
              child: _selectedRoute != null
                  ? _buildRouteDetails()
                  : const Center(
                      child: Text('No route selected'),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportModeSelector() {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.5 + 20,
      left: 16,
      right: 16,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildTransportModeButton('driving', Icons.directions_car),
            _buildTransportModeButton('transit', Icons.directions_transit),
            _buildTransportModeButton('walking', Icons.directions_walk),
            _buildTransportModeButton('cycling', Icons.directions_bike),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportModeButton(String mode, IconData icon) {
    final isSelected = _selectedTransportMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTransportMode = mode;
          });
          _getDirections();
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[50] : Colors.transparent,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.blue[600] : Colors.grey[600],
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildMapControls() {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        children: [
          // My location button
          _buildMapControlButton(
            icon: Icons.my_location,
            onTap: _goToMyLocation,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          // Layers button
          _buildMapControlButton(
            icon: Icons.layers,
            onTap: _toggleLayers,
            color: Colors.grey[600]!,
          ),
        ],
      ),
    );
  }

  Widget _buildMapControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),
    );
  }

  // Functionality methods
  void _onSearchChanged(String query) async {
    if (query.length < 3) {
      setState(() {
        _searchResults.clear();
        _showSearchResults = false;
      });
      return;
    }

    setState(() {
      // Searching...
    });

    try {
      final results = await _searchPlaces(query);
      setState(() {
        _searchResults = results;
        _showSearchResults = true;
      });
    } catch (e) {
      setState(() {
        // Search failed
      });
      _showErrorDialog('Search Error', 'Failed to search places: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _searchPlaces(String query) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$_googleMapsApiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['results'] ?? []);
      }
      return [];
    } catch (e) {
      print('Places API error: $e');
      return [];
    }
  }

  void _selectSearchResult(Map<String, dynamic> result) {
    final lat = result['geometry']['location']['lat'];
    final lng = result['geometry']['location']['lng'];
    final location = LatLng(lat, lng);

    setState(() {
      _showSearchResults = false;
      _searchController.text = result['name'] ?? '';
    });

    // Add marker
    _addMarker(
      location,
      result['name'] ?? 'Selected Location',
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );

    // Move camera to location
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(location, 15.0),
    );
  }

  Future<void> _getDirections() async {
    if (_fromController.text.isEmpty || _toController.text.isEmpty) {
      _showErrorDialog('Missing Information', 'Please enter both origin and destination');
      return;
    }

    setState(() {
      // Getting directions...
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/directions/json?origin=${_fromController.text}&destination=${_toController.text}&mode=$_selectedTransportMode&key=$_googleMapsApiKey',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          _displayRoute(route);
          setState(() {
            _showDirections = true;
            _selectedRoute = route;
          });
        } else {
          _showErrorDialog('No Route Found', 'No route found between the selected locations');
        }
      }
    } catch (e) {
      setState(() {
        // Directions failed
      });
      _showErrorDialog('Directions Error', 'Failed to get directions: $e');
    }
  }

  void _displayRoute(Map<String, dynamic> route) {
    final points = <LatLng>[];
    final legs = route['legs'] as List;
    
    for (final leg in legs) {
      final steps = leg['steps'] as List;
      for (final step in steps) {
        final startLocation = step['start_location'];
        final endLocation = step['end_location'];
        
        points.add(LatLng(
          startLocation['lat'],
          startLocation['lng'],
        ));
        points.add(LatLng(
          endLocation['lat'],
          endLocation['lng'],
        ));
      }
    }

    setState(() {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: Colors.blue,
          width: 5,
        ),
      );
    });
  }

  void _goToMyLocation() {
    if (_currentLocation != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 15.0),
      );
    } else {
      _showErrorDialog('Location Error', 'Current location not available');
    }
  }

  void _toggleLayers() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Map Type',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMapTypeOption('Normal', Icons.map, MapType.normal),
                  _buildMapTypeOption('Satellite', Icons.satellite, MapType.satellite),
                  _buildMapTypeOption('Terrain', Icons.terrain, MapType.terrain),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapTypeOption(String title, IconData icon, MapType mapType) {
    final isSelected = _currentMapType == mapType;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Colors.blue : Colors.grey[600],
      ),
      title: Text(
        title,
        style: GoogleFonts.roboto(
          color: isSelected ? Colors.blue : Colors.black87,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: () {
        setState(() {
          _currentMapType = mapType;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Menu',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMenuOption('Settings', Icons.settings),
                  _buildMenuOption('Help', Icons.help),
                  _buildMenuOption('About', Icons.info),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(
        title,
        style: GoogleFonts.roboto(
          color: Colors.black87,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        // Handle menu option
      },
    );
  }

  Widget _buildRouteDetails() {
    if (_selectedRoute == null) return const SizedBox.shrink();

    final legs = _selectedRoute!['legs'] as List;
    final firstLeg = legs.isNotEmpty ? legs[0] : null;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Route summary
          if (firstLeg != null) ...[
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    _getTransportIcon(_selectedTransportMode),
                    color: Colors.blue[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        firstLeg['duration']['text'],
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        firstLeg['distance']['text'],
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Start navigation
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Start',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
          // Route steps
          Expanded(
            child: ListView.builder(
              itemCount: legs.length,
              itemBuilder: (context, index) {
                final leg = legs[index];
                return _buildRouteStep(leg, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteStep(Map<String, dynamic> leg, int index) {
    final steps = leg['steps'] as List;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index > 0) const Divider(),
        ...steps.map((step) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  _getStepIcon(step['html_instructions']),
                  size: 16,
                  color: Colors.blue[600],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _stripHtml(step['html_instructions']),
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                step['duration']['text'],
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  IconData _getTransportIcon(String mode) {
    switch (mode) {
      case 'driving':
        return Icons.directions_car;
      case 'transit':
        return Icons.directions_transit;
      case 'walking':
        return Icons.directions_walk;
      case 'cycling':
        return Icons.directions_bike;
      default:
        return Icons.directions;
    }
  }

  IconData _getStepIcon(String instruction) {
    if (instruction.toLowerCase().contains('turn')) {
      return Icons.turn_right;
    } else if (instruction.toLowerCase().contains('straight')) {
      return Icons.straight;
    } else if (instruction.toLowerCase().contains('left')) {
      return Icons.turn_left;
    } else if (instruction.toLowerCase().contains('right')) {
      return Icons.turn_right;
    }
    return Icons.navigation;
  }

  String _stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}