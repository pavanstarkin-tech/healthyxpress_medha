import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Custom Mapbox Marker Model
class MapboxMarkerItem {
  final String id;
  final double lng;
  final double lat;
  final String title;
  final String color;
  final String iconHtml;
  final String? popupText;
  final String? popupHtml;
  final bool draggable;
  final bool isRawHtml;
  final double width;
  final double height;
  final String anchor;

  const MapboxMarkerItem({
    required this.id,
    required this.lng,
    required this.lat,
    this.title = '',
    this.color = '#2563EB',
    this.iconHtml = '📍',
    this.popupText,
    this.popupHtml,
    this.draggable = false,
    this.isRawHtml = true,
    this.width = 38,
    this.height = 48,
    this.anchor = 'bottom',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'color': color,
        'iconHtml': iconHtml,
        'popupText': popupText ?? title,
        'popupHtml': popupHtml,
        'draggable': draggable,
        'isRawHtml': isRawHtml,
        'width': width,
        'height': height,
        'anchor': anchor,
      };
}

class RealMapboxMap extends StatefulWidget {
  final double initialLng;
  final double initialLat;
  final double initialZoom;
  final List<MapboxMarkerItem> markers;
  final List<List<double>>? routeCoordinates;
  final bool interactive;
  final double height;
  final BorderRadius? borderRadius;
  final VoidCallback? onLocateMe;

  const RealMapboxMap({
    super.key,
    this.initialLng = 78.3880,
    this.initialLat = 17.4420,
    this.initialZoom = 14.0,
    this.markers = const [],
    this.routeCoordinates,
    this.interactive = true,
    this.height = 220,
    this.borderRadius,
    this.onLocateMe,
  });

  @override
  State<RealMapboxMap> createState() => RealMapboxMapState();
}

class RealMapboxMapState extends State<RealMapboxMap> {
  bool get isMapReady => true;
  bool get isSatellite => false;

  void flyTo(double lng, double lat, {double zoom = 15.0}) {}
  void addMarker(MapboxMarkerItem marker) {}
  void clearMarkers() {}
  void resize() {}
  void toggleMapStyle() {}

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(16);

    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: radius,
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_rounded, size: 36, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              'Interactive GPS Map View',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.markers.length} nearby locations mapped',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
