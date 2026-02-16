import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../../services/location_service.dart';
import '../checkin_controller.dart';

class CheckInMap extends GetView<CheckinController> {
  const CheckInMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pos = controller.selectedOffice.value;
      final currentPos = Get.find<ILocationService>().currentPosition.value;

      return FlutterMap(
        options: MapOptions(
          initialCenter: currentPos != null
              ? LatLng(currentPos.latitude, currentPos.longitude)
              : (pos != null
                  ? LatLng(pos.lat, pos.lng)
                  : const LatLng(-6.2000, 106.8166)),
          initialZoom: 16.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'id.sinergo.app',
          ),
          if (pos != null)
            CircleLayer(
              circles: [
                CircleMarker(
                  point: LatLng(pos.lat, pos.lng),
                  radius: pos.radius,
                  useRadiusInMeter: true,
                  color: Colors.green.withValues(alpha: 0.3),
                  borderColor: Colors.green,
                  borderStrokeWidth: 2,
                ),
              ],
            ),
          MarkerLayer(
            markers: [
              if (pos != null)
                Marker(
                  point: LatLng(pos.lat, pos.lng),
                  width: 40,
                  height: 40,
                  child:
                      const Icon(Icons.business, color: Colors.blue, size: 30),
                ),
              if (currentPos != null)
                Marker(
                  point: LatLng(currentPos.latitude, currentPos.longitude),
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.person_pin_circle,
                      color: Colors.red, size: 40),
                ),
            ],
          ),
        ],
      );
    });
  }
}
