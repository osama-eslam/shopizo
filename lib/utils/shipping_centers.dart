import 'package:latlong2/latlong.dart';

List<LatLng> shippingCenters = [
  LatLng(30.0444, 31.2357),
  LatLng(30.0131, 31.2089),
  LatLng(31.2001, 29.9187),
  LatLng(31.0409, 31.3785),
  LatLng(31.2586, 32.3019),
  LatLng(30.5852, 31.5016),
  LatLng(30.7958, 31.0015),
  LatLng(30.5003, 31.7001),
  LatLng(30.0561, 31.3403),
  LatLng(30.8369, 31.0004),
  LatLng(31.0936, 31.3909),
  LatLng(30.9187, 31.2066),
  LatLng(30.9364, 31.2690),
  LatLng(29.9553, 31.2766),
  LatLng(31.5626, 27.1800),
  LatLng(28.0408, 30.8328),
  LatLng(26.8206, 30.8025),
  LatLng(27.2579, 33.8125),
  LatLng(29.8668, 33.9148),
  LatLng(26.5364, 31.7004),
  LatLng(25.6872, 32.6396),
  LatLng(30.0686, 31.3480),
  LatLng(27.2579, 33.8125),
  LatLng(29.9711, 31.3036),
  LatLng(31.3260, 30.1230),
  LatLng(31.0422, 31.3785),
  LatLng(30.8508, 29.6133),
  LatLng(30.1110, 31.3241),
  LatLng(30.9333, 30.8500),
  LatLng(31.0651, 31.3785),
];

LatLng findNearestShippingCenter(LatLng deliveryPoint, List<LatLng> centers) {
  final Distance distance = Distance();

  LatLng nearest = centers[0];
  double minDistance = distance(deliveryPoint, nearest);

  for (var center in centers) {
    double dist = distance(deliveryPoint, center);
    if (dist < minDistance) {
      minDistance = dist;
      nearest = center;
    }
  }
  return nearest;
}
