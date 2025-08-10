import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MiniMapPreview extends StatelessWidget {
  final LatLng startPoint;
  final LatLng endPoint;
  final List<LatLng> pathPoints;
  final LatLng carPosition;
  final VoidCallback onTap;

  const MiniMapPreview({
    Key? key,
    required this.startPoint,
    required this.endPoint,
    required this.pathPoints,
    required this.carPosition,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          child: AbsorbPointer(
            child: FlutterMap(
              options: MapOptions(
                center: carPosition,
                zoom: 14,
                maxZoom: 18,
                minZoom: 5,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: const ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.app',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: pathPoints,
                      strokeWidth: 4,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: startPoint,
                      builder:
                          (ctx) => const Icon(
                            Icons.local_shipping,
                            color: Colors.blue,
                            size: 36,
                          ),
                    ),
                    Marker(
                      point: endPoint,
                      builder:
                          (ctx) => const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 36,
                          ),
                    ),
                    Marker(
                      point: carPosition,
                      width: 40,
                      height: 40,
                      builder:
                          (ctx) => const Icon(
                            Icons.directions_car,
                            color: Colors.green,
                            size: 40,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
